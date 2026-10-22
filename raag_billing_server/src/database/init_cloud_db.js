const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

async function initCloudDatabase() {
  console.log('🚀 Initializing Cloud MySQL Database Schema...');

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
  });

  try {
    const schemaPath = path.join(__dirname, 'schema.sql');
    const sql = fs.readFileSync(schemaPath, 'utf8');

    // Split SQL queries by semicolon
    const statements = sql
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0 && !s.startsWith('--') && !s.startsWith('CREATE DATABASE') && !s.startsWith('USE'));

    for (const statement of statements) {
      if (statement) {
        await connection.query(statement);
      }
    }

    console.log('✅ Cloud MySQL Database Schema & Tables initialized successfully!');
  } catch (error) {
    console.error('❌ Error initializing Cloud Database:', error.message);
  } finally {
    await connection.end();
  }
}

if (require.main === module) {
  initCloudDatabase()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}

module.exports = initCloudDatabase;
