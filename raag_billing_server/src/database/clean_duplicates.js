const mysql = require('mysql2/promise');
require('dotenv').config();

async function cleanDuplicateRows() {
  console.log('🧹 Cleaning duplicate rows in XAMPP MySQL database (raag_billing_db)...');

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : '',
    database: process.env.DB_NAME || 'raag_billing_db',
  });

  try {
    // 1. Delete duplicate categories keeping the earliest record (smallest ID)
    const [catRes] = await connection.query(`
      DELETE c1 FROM categories c1
      INNER JOIN categories c2
      WHERE c1.id > c2.id
        AND c1.user_id = c2.user_id
        AND LOWER(TRIM(c1.name)) = LOWER(TRIM(c2.name))
    `);
    console.log(`✅ Deleted ${catRes.affectedRows} duplicate category rows.`);

    // 2. Delete duplicate products keeping the earliest record (smallest ID)
    const [prodRes] = await connection.query(`
      DELETE p1 FROM products p1
      INNER JOIN products p2
      WHERE p1.id > p2.id
        AND p1.user_id = p2.user_id
        AND LOWER(TRIM(p1.name)) = LOWER(TRIM(p2.name))
    `);
    console.log(`✅ Deleted ${prodRes.affectedRows} duplicate product rows.`);

    // 3. Delete duplicate customers keeping the earliest record (smallest ID)
    const [custRes] = await connection.query(`
      DELETE c1 FROM customers c1
      INNER JOIN customers c2
      WHERE c1.id > c2.id
        AND c1.user_id = c2.user_id
        AND LOWER(TRIM(c1.name)) = LOWER(TRIM(c2.name))
    `);
    console.log(`✅ Deleted ${custRes.affectedRows} duplicate customer rows.`);

  } catch (error) {
    console.error('❌ Error cleaning duplicates:', error.message);
  } finally {
    await connection.end();
  }
}

if (require.main === module) {
  cleanDuplicateRows()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}

module.exports = cleanDuplicateRows;
