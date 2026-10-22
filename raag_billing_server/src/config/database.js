const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306', 10),
  user: process.env.DB_USER || 'root',

  // FIXED
  password:
    process.env.DB_PASSWORD !== undefined
      ? process.env.DB_PASSWORD
      : '',

  database: process.env.DB_NAME || 'raag_billing_db',

  waitForConnections: true,
  connectionLimit: parseInt(process.env.DB_CONNECTION_LIMIT || '10', 10),
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 10000,
});

async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('✅ Connected to MySQL Database Pool successfully');
    connection.release();
  } catch (error) {
    console.error('❌ Unable to connect to MySQL Database Pool:', error.message);
  }
}

testConnection();

module.exports = pool;