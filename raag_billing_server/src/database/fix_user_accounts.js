const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
require('dotenv').config();

async function fixUserAccounts() {
  console.log('🔄 Executing User Account Re-linking & Account Creation Script...');

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : '',
    database: process.env.DB_NAME || 'raag_billing_db',
  });

  try {
    const salt = await bcrypt.genSalt(10);
    const defaultPasswordHash = await bcrypt.hash('password123', salt);

    // 1. Ensure User 1 exists (Harsh Kumar)
    console.log('👤 Ensuring User ID = 1 (Harsh Kumar) exists...');
    await connection.query(`
      INSERT INTO users (id, name, email, phone, password)
      VALUES (1, 'Harsh Kumar', 'harsh@example.com', '7091576133', ?)
      ON DUPLICATE KEY UPDATE
        name = 'Harsh Kumar',
        email = 'harsh@example.com',
        phone = '7091576133'
    `, [defaultPasswordHash]);

    // 2. Link all data from user_id = 2 to user_id = 1
    console.log('🔗 Re-linking all user 2 data to user_id = 1...');
    const tablesToUpdate = [
      'business_profiles',
      'categories',
      'products',
      'customers',
      'invoices',
      'invoice_items',
      'payments',
      'stock_movements',
      'purchases',
      'purchase_items'
    ];

    for (const table of tablesToUpdate) {
      try {
        if (table === 'business_profiles') {
          // Keep the existing profile for user 1 if present
          await connection.query('DELETE FROM business_profiles WHERE user_id = 1 AND id > 1');
          await connection.query('UPDATE IGNORE business_profiles SET user_id = 1 WHERE user_id = 2');
        } else {
          await connection.query(`UPDATE ${table} SET user_id = 1 WHERE user_id = 2`);
        }
      } catch (err) {
        console.log(`  └─ Note on ${table}: ${err.message}`);
      }
    }

    // 3. Delete old user 2 if present to free up ID 2
    console.log('🧹 Cleaning up old User ID = 2...');
    await connection.query('DELETE FROM users WHERE id = 2');

    // 4. Create new User 2 (Ankit Kr, mob: 9876543210)
    console.log('👤 Creating NEW User ID = 2 for Ankit Kr (mob: 9876543210)...');
    await connection.query(`
      INSERT INTO users (id, name, email, phone, password, is_active)
      VALUES (2, 'Ankit Kr', 'ankit@example.com', '9876543210', ?, 1)
    `, [defaultPasswordHash]);

    // 5. Create Business Profile for User 2 (Ankit Kr)
    console.log('🏢 Creating Business Profile for User ID = 2 (Ankit Kr)...');
    await connection.query(`
      INSERT INTO business_profiles (user_id, business_name, owner_name, email, phone)
      VALUES (2, "Ankit Kr's Business", 'Ankit Kr', 'ankit@example.com', '9876543210')
      ON DUPLICATE KEY UPDATE
        business_name = "Ankit Kr's Business",
        owner_name = 'Ankit Kr',
        email = 'ankit@example.com',
        phone = '9876543210'
    `);

    // 6. Reset AUTO_INCREMENT on users table
    console.log('🔢 Setting AUTO_INCREMENT on users table to 3...');
    await connection.query('ALTER TABLE users AUTO_INCREMENT = 3');

    console.log('\n========================================================');
    console.log('✅ ACCOUNTS SUCCESSFULLY CONFIGURED IN MYSQL!');
    console.log('========================================================');
    console.log('👤 USER ID 1: Harsh Kumar (Email: harsh@example.com, Phone: 7091576133)');
    console.log('👤 USER ID 2: Ankit Kr (Email: ankit@example.com, Phone: 9876543210)');
    console.log('🔑 Password for both accounts: password123');
    console.log('========================================================\n');

  } catch (error) {
    console.error('❌ Error configuring user accounts:', error.message);
  } finally {
    await connection.end();
  }
}

fixUserAccounts();
