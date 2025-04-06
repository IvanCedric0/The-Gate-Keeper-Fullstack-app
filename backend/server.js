const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const FormData = require('form-data');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const QRCode = require('qrcode');
const fs = require('fs');

const app = express();
const port = 3000;

// JWT Secret Key
const JWT_SECRET = 'your-secret-key-here';

// ImgBB API Key
const IMGBB_API_KEY = '8afd0d8543f84fe58a0072291f88477a';

// CORS configuration - more permissive for development
app.use(cors({
  origin: true, // Allow all origins during development
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

// Middleware
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something broke!' });
});

// Authentication middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access denied. No token provided.' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token.' });
    }
    req.user = user;
    next();
  });
};

// MySQL connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',  // default WAMP password is empty
  database: 'gatekeeper_db'
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL database: gatekeeper_db');
  
  // Create admin table if it doesn't exist
  const createAdminTable = `
    CREATE TABLE IF NOT EXISTS admins (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(50) UNIQUE NOT NULL,
      password VARCHAR(255) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `;
  
  db.query(createAdminTable, (err) => {
    if (err) {
      console.error('Error creating admin table:', err);
      return;
    }
    console.log('Admin table checked/created successfully');
    
    // Check if default admin exists
    const checkAdmin = 'SELECT * FROM admins WHERE username = ?';
    db.query(checkAdmin, ['admin'], async (err, results) => {
      if (err) {
        console.error('Error checking admin:', err);
        return;
      }
      
      if (results.length === 0) {
        // Create default admin if not exists
        const hashedPassword = await bcrypt.hash('gate808', 10);
        const insertAdmin = 'INSERT INTO admins (username, password) VALUES (?, ?)';
        db.query(insertAdmin, ['admin', hashedPassword], (err) => {
          if (err) {
            console.error('Error creating default admin:', err);
            return;
          }
          console.log('Default admin created successfully');
        });
      } else {
        console.log('Default admin already exists');
      }
    });

    // Check all admin accounts
    db.query('SELECT id, username, created_at FROM admins', (err, results) => {
      if (err) {
        console.error('Error checking admin accounts:', err);
        return;
      }
      console.log('Current admin accounts:', results);
    });
  });

  // Create student_logs table if it doesn't exist
  db.query(`
    CREATE TABLE IF NOT EXISTS student_logs (
      id INT AUTO_INCREMENT PRIMARY KEY,
      student_id INT NOT NULL,
      entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      exit_time TIMESTAMP NULL,
      status ENUM('entered', 'exited') DEFAULT 'entered',
      FOREIGN KEY (student_id) REFERENCES students(id)
    )
  `, (err) => {
    if (err) {
      console.error('Error creating student_logs table:', err);
      return;
    }
    console.log('Student logs table checked/created successfully');
  });
});

// Configure multer for local file storage
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/')
  },
  filename: function (req, file, cb) {
    // Generate unique filename using timestamp and original extension
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
    cb(null, uniqueSuffix + path.extname(file.originalname))
  }
});

const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    // Accept only image files
    if (file.mimetype.startsWith('image/')) {
      cb(null, true)
    } else {
      cb(new Error('Only image files are allowed!'))
    }
  }
})

// Function to generate QR code
async function generateQRCode(studentId) {
  try {
    // Generate QR code as data URL
    const qrDataUrl = await QRCode.toDataURL(studentId.toString());
    return qrDataUrl;
  } catch (error) {
    console.error('Error generating QR code:', error);
    throw new Error('Failed to generate QR code');
  }
}

// Routes
// Login route
app.post('/api/login', async (req, res) => {
  const { username, password } = req.body;
  console.log('Login attempt for username:', username);

  try {
    const query = 'SELECT * FROM admins WHERE username = ?';
    db.query(query, [username], async (err, results) => {
      if (err) {
        console.error('Database error during login:', err);
        return res.status(500).json({ error: 'Database error' });
      }

      console.log('Database query results:', results);

      if (results.length === 0) {
        console.log('No admin found with username:', username);
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      const admin = results[0];
      console.log('Found admin:', { id: admin.id, username: admin.username });
      
      const validPassword = await bcrypt.compare(password, admin.password);
      console.log('Password validation result:', validPassword);

      if (!validPassword) {
        console.log('Invalid password for username:', username);
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      const token = jwt.sign({ id: admin.id, username: admin.username }, JWT_SECRET);
      console.log('Login successful for username:', username);
      res.json({ token });
    });
  } catch (error) {
    console.error('Server error during login:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get all students (protected route)
app.get('/api/students', authenticateToken, (req, res) => {
  const query = 'SELECT * FROM students';
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching students:', err);
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(results);
  });
});

// Add new student (protected route)
app.post('/api/students', authenticateToken, upload.single('photo'), async (req, res) => {
  try {
    console.log('Received student data:', req.body);
    console.log('Received file:', req.file);

    const { id, fullname, major } = req.body;
    
    if (!req.file) {
      console.log('No file provided');
      return res.status(400).json({ error: 'No image file provided' });
    }

    // Generate QR code
    console.log('Generating QR code for ID:', id);
    const qrCode = await generateQRCode(id);
    console.log('QR code generated successfully');

    // Store student data with QR code
    const query = 'INSERT INTO students (id, fullname, major, photo, qr_code) VALUES (?, ?, ?, ?, ?)';
    const photoPath = `http://localhost:3000/uploads/${path.basename(req.file.path)}`;
    console.log('Executing database query with values:', { id, fullname, major, photoPath, qrCode });
    
    db.query(query, [id, fullname, major, photoPath, qrCode], (err, result) => {
      if (err) {
        console.error('Database error:', err);
        res.status(500).json({ error: err.message });
        return;
      }
      console.log('Student added successfully:', result);
      res.json({ 
        id: result.insertId, 
        message: 'Student added successfully',
        qrCode 
      });
    });
  } catch (error) {
    console.error('Error in student addition:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get student by ID
app.get('/api/students/:id', async (req, res) => {
  const studentId = req.params.id;
  
  try {
    // Get student information
    const studentQuery = 'SELECT * FROM students WHERE id = ?';
    db.query(studentQuery, [studentId], (err, results) => {
      if (err) {
        console.error('Error fetching student:', err);
        return res.status(500).json({ error: 'Database error' });
      }

      if (results.length === 0) {
        return res.status(404).json({ error: 'Student not found' });
      }

      const student = results[0];

      // Get latest log entry
      const logQuery = 'SELECT * FROM student_logs WHERE student_id = ? ORDER BY entry_time DESC LIMIT 1';
      db.query(logQuery, [studentId], (err, logResults) => {
        if (err) {
          console.error('Error fetching student log:', err);
          return res.status(500).json({ error: 'Database error' });
        }

        if (logResults.length > 0) {
          student.entry_time = logResults[0].entry_time;
          student.exit_time = logResults[0].exit_time;
          student.status = logResults[0].status;
        }

        res.json(student);
      });
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Log student entry
app.post('/api/students/:id/entry', async (req, res) => {
  const studentId = req.params.id;
  const { entry_time } = req.body;

  try {
    const query = 'INSERT INTO student_logs (student_id, entry_time, status) VALUES (?, ?, ?)';
    db.query(query, [studentId, entry_time, 'entered'], (err, result) => {
      if (err) {
        console.error('Error logging student entry:', err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.json({ message: 'Entry logged successfully' });
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Log student exit
app.post('/api/students/:id/exit', async (req, res) => {
  const studentId = req.params.id;
  const { exit_time } = req.body;

  try {
    const query = 'UPDATE student_logs SET exit_time = ?, status = ? WHERE student_id = ? AND status = ?';
    db.query(query, [exit_time, 'exited', studentId, 'entered'], (err, result) => {
      if (err) {
        console.error('Error logging student exit:', err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.json({ message: 'Exit logged successfully' });
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Update student route
app.put('/api/students/:id', authenticateToken, upload.single('photo'), async (req, res) => {
  const { id } = req.params;
  const { fullname, major } = req.body;
  let photoPath = null;

  try {
    // If a new photo was uploaded
    if (req.file) {
      photoPath = `http://localhost:3000/uploads/${path.basename(req.file.path)}`;
    }

    // Build the update query based on what's being updated
    let updateFields = [];
    let queryParams = [];

    if (fullname) {
      updateFields.push('fullname = ?');
      queryParams.push(fullname);
    }
    if (major) {
      updateFields.push('major = ?');
      queryParams.push(major);
    }
    if (photoPath) {
      updateFields.push('photo = ?');
      queryParams.push(photoPath);
    }

    if (updateFields.length === 0) {
      return res.status(400).json({ error: 'No fields to update' });
    }

    queryParams.push(id); // Add id for WHERE clause

    const query = `UPDATE students SET ${updateFields.join(', ')} WHERE id = ?`;
    
    db.query(query, queryParams, (err, result) => {
      if (err) {
        console.error('Error updating student:', err);
        return res.status(500).json({ error: 'Failed to update student' });
      }
      res.json({ message: 'Student updated successfully' });
    });
  } catch (error) {
    console.error('Error in update route:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete student route
app.delete('/api/students/:id', authenticateToken, (req, res) => {
  const { id } = req.params;

  // First, get the student's photo path
  db.query('SELECT photo FROM students WHERE id = ?', [id], (err, results) => {
    if (err) {
      console.error('Error fetching student photo:', err);
      return res.status(500).json({ error: 'Failed to fetch student data' });
    }

    if (results.length === 0) {
      return res.status(404).json({ error: 'Student not found' });
    }

    const photoPath = results[0].photo;
    
    // Delete the student from the database
    db.query('DELETE FROM students WHERE id = ?', [id], (err, result) => {
      if (err) {
        console.error('Error deleting student:', err);
        return res.status(500).json({ error: 'Failed to delete student' });
      }

      // If the student had a photo, delete it from the uploads directory
      if (photoPath) {
        const filename = path.basename(photoPath);
        const filePath = path.join(__dirname, 'uploads', filename);
        
        fs.unlink(filePath, (err) => {
          if (err) {
            console.error('Error deleting photo file:', err);
          }
        });
      }

      res.json({ message: 'Student deleted successfully' });
    });
  });
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`CORS enabled for http://localhost:5173`);
});
