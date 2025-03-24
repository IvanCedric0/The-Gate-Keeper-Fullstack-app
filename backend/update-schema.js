const mysql = require('mysql2');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'gatekeeper_db'
});

async function updateSchema() {
  try {
    await db.promise().connect();
    console.log('Connected to database');

    // First, check if the students table exists
    const [tables] = await db.promise().query('SHOW TABLES LIKE "students"');
    if (tables.length === 0) {
      console.log('Creating students table...');
      await db.promise().query(`
        CREATE TABLE students (
          id VARCHAR(20) PRIMARY KEY,
          fullname VARCHAR(100) NOT NULL,
          major VARCHAR(100) NOT NULL,
          photo TEXT,
          qr_code TEXT
        )
      `);
      console.log('Students table created successfully');
    } else {
      console.log('Students table already exists');
    }

    // Check if qr_code column exists
    const [columns] = await db.promise().query('SHOW COLUMNS FROM students LIKE "qr_code"');
    
    if (columns.length === 0) {
      console.log('Adding qr_code column...');
      await db.promise().query(`
        ALTER TABLE students 
        ADD COLUMN qr_code TEXT
      `);
      console.log('Added qr_code column to students table');
    } else {
      console.log('qr_code column already exists');
    }

    // Verify the table structure
    const [tableStructure] = await db.promise().query('DESCRIBE students');
    console.log('Current table structure:', tableStructure);

    await db.end();
    console.log('Database connection closed');
  } catch (error) {
    console.error('Error:', error);
    await db.end();
  }
}

updateSchema(); 