const mysql = require('mysql2/promise');
require('dotenv').config();

async function copyDataToUser1() {
  console.log('🔄 Copying sample customers and invoices to User ID 1 (Harsh Kumar)...');

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : '',
    database: process.env.DB_NAME || 'raag_billing_db',
  });

  try {
    // 1. Ensure Walk-in Customer exists for User 1
    const [custResult] = await connection.query(`
      INSERT INTO customers (user_id, name, phone, email, address)
      VALUES (1, 'Ramesh Sharma', '9876543210', 'ramesh@example.com', 'Sector 15, Noida')
      ON DUPLICATE KEY UPDATE name = 'Ramesh Sharma'
    `);
    const customerId = custResult.insertId || 1;

    // 2. Ensure Invoice exists for User 1
    await connection.query(`
      INSERT INTO invoices (
        user_id, customer_id, invoice_number, date, subtotal, tax_amount, grand_total, paid_amount, due_amount, payment_method
      ) VALUES (
        1, ?, 'HKS-000001', CURRENT_TIMESTAMP, 300.00, 34.00, 334.00, 334.00, 0.00, 'Cash'
      )
      ON DUPLICATE KEY UPDATE grand_total = 334.00
    `, [customerId]);

    console.log('✅ Successfully created sample Customer and Invoice for User ID 1 (Harsh Kumar)!');

  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await connection.end();
  }
}

copyDataToUser1();
