const mysql = require('mysql2/promise');
require('dotenv').config();

async function dumpUserData(targetUserId = 1) {
  console.log(`🔍 Exporting complete database records for user_id = ${targetUserId} from XAMPP MySQL...`);

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : '',
    database: process.env.DB_NAME || 'raag_billing_db',
  });

  try {
    const dump = {};

    // 1. User Account
    const [users] = await connection.query('SELECT id, name, email, phone, is_active, created_at FROM users WHERE id = ?', [targetUserId]);
    dump.user = users[0] || null;

    // 2. Business Profile
    const [profiles] = await connection.query('SELECT * FROM business_profiles WHERE user_id = ?', [targetUserId]);
    dump.businessProfile = profiles[0] || null;

    // 3. Categories
    const [categories] = await connection.query('SELECT * FROM categories WHERE user_id = ? ORDER BY id ASC', [targetUserId]);
    dump.categories = categories;

    // 4. Products
    const [products] = await connection.query('SELECT * FROM products WHERE user_id = ? ORDER BY id ASC', [targetUserId]);
    dump.products = products;

    // 5. Customers
    const [customers] = await connection.query('SELECT * FROM customers WHERE user_id = ? ORDER BY id ASC', [targetUserId]);
    dump.customers = customers;

    // 6. Invoices & Items
    const [invoices] = await connection.query('SELECT * FROM invoices WHERE user_id = ? ORDER BY id ASC', [targetUserId]);
    const [invoiceItems] = await connection.query('SELECT * FROM invoice_items WHERE user_id = ? ORDER BY id ASC', [targetUserId]);
    dump.invoices = invoices;
    dump.invoiceItems = invoiceItems;

    // 7. Purchases & Items
    const [purchases] = await connection.query('SELECT * FROM purchases WHERE user_id = ? ORDER BY id ASC', [targetUserId]);
    const [purchaseItems] = await connection.query('SELECT * FROM purchase_items WHERE user_id = ? ORDER BY id ASC', [targetUserId]);
    dump.purchases = purchases;
    dump.purchaseItems = purchaseItems;

    // 8. Stock Movements
    const [movements] = await connection.query('SELECT * FROM stock_movements WHERE user_id = ? ORDER BY id ASC', [targetUserId]);
    dump.stockMovements = movements;

    console.log('\n========================================================');
    console.log(`📦 COMPLETE DATA DUMP FOR USER_ID = ${targetUserId}:`);
    console.log('========================================================');
    console.log(JSON.stringify(dump, null, 2));

  } catch (error) {
    console.error('❌ Error exporting user data:', error.message);
  } finally {
    await connection.end();
  }
}

dumpUserData(1);
