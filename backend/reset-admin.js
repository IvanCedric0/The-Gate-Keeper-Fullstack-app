const mysql = require('mysql2');
const bcrypt = require('bcrypt');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'gatekeeper_db'
});

async function resetAdmin() {
  try {
    await db.promise().connect();
    console.log('Connected to database');

    // Drop the admins table if it exists
    await db.promise().query('DROP TABLE IF EXISTS admins');
    console.log('Dropped existing admins table');

    // Create the admins table
    await db.promise().query(`
      CREATE TABLE admins (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('Created new admins table');

    // Create new admin account
    const hashedPassword = await bcrypt.hash('gate808', 10);
    await db.promise().query(
      'INSERT INTO admins (username, password) VALUES (?, ?)',
      ['admin', hashedPassword]
    );
    console.log('Created new admin account');

    // Verify the admin account
    const [results] = await db.promise().query('SELECT * FROM admins');
    console.log('Current admin accounts:', results);

    await db.end();
    console.log('Database connection closed');
  } catch (error) {
    console.error('Error:', error);
    await db.end();
  }
}

resetAdmin(); 