const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
const cleanDuplicateRows = require('./clean_duplicates');
require('dotenv').config();

async function initializeDatabase() {
  const host = process.env.DB_HOST || 'localhost';
  const port = process.env.DB_PORT || 3306;
  const user = process.env.DB_USER || 'root';
  const password = process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : '';

  console.log(`🔄 Attempting MySQL Database connection (${host}:${port}, user: ${user})...`);

  let connection;
  try {
    connection = await mysql.createConnection({
      host,
      port,
      user,
      password,
      multipleStatements: true,
    });

    const schemaPath = path.join(__dirname, 'schema.sql');
    const sql = fs.readFileSync(schemaPath, 'utf8');

    await connection.query(sql);
    console.log('✅ MySQL Database Schema & Tables initialized successfully!');

    // Clean any existing duplicate rows automatically
    await cleanDuplicateRows();
    return true;
  } catch (error) {
    console.error('\n======================================================');
    console.error('❌ MYSQL CONNECTION ERROR:', error.code || error.message);
    console.error('------------------------------------------------------');
    if (error.code === 'ECONNREFUSED') {
      console.error('⚠️  MySQL server is NOT running on ' + host + ':' + port);
      console.error('👉 Fix options:');
      console.error('   1. Start MySQL service on Windows: net start MySQL80');
      console.error('   2. Or start MySQL from XAMPP / WAMP / MySQL Workbench.');
      console.error('   3. Verify DB_HOST, DB_PORT in raag_billing_server/.env');
    } else if (error.code === 'ER_ACCESS_DENIED_ERROR') {
      console.error('⚠️  Access denied for user "' + user + '".');
      console.error('👉 Fix option: Update DB_USER and DB_PASSWORD in raag_billing_server/.env');
    } else {
      console.error('👉 Details:', error.message);
    }
    console.error('======================================================\n');
    return false;
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

if (require.main === module) {
  initializeDatabase()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}

module.exports = initializeDatabase;
