const mysql = require('mysql2/promise');
require('dotenv').config();

async function listAllData() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : '',
    database: process.env.DB_NAME || 'raag_billing_db',
  });

  try {
    const [users] = await connection.query('SELECT id, name, email, phone, created_at FROM users');
    console.log('👥 ALL REGISTERED USERS IN MYSQL:');
    console.table(users);

    const [profiles] = await connection.query('SELECT id, user_id, business_name, owner_name, email, phone FROM business_profiles');
    console.log('\n🏢 ALL BUSINESS PROFILES IN MYSQL:');
    console.table(profiles);

    const [products] = await connection.query('SELECT id, user_id, name, selling_price, current_stock FROM products');
    console.log('\n📦 ALL PRODUCTS IN MYSQL:');
    console.table(products);

    const [categories] = await connection.query('SELECT id, user_id, name FROM categories');
    console.log('\n📁 ALL CATEGORIES IN MYSQL:');
    console.table(categories);

    const [customers] = await connection.query('SELECT id, user_id, name, phone FROM customers');
    console.log('\n👥 ALL CUSTOMERS IN MYSQL:');
    console.table(customers);

    const [invoices] = await connection.query('SELECT id, user_id, invoice_number, grand_total, date FROM invoices');
    console.log('\n🧾 ALL INVOICES IN MYSQL:');
    console.table(invoices);

  } catch (error) {
    console.error('❌ Error reading database:', error.message);
  } finally {
    await connection.end();
  }
}

listAllData();
