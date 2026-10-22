const db = require('../config/database');

class PurchaseModel {
  static async generatePurchaseNumber(userId) {
    const [rows] = await db.execute(
      'SELECT id FROM purchases WHERE user_id = ? ORDER BY id DESC LIMIT 1',
      [userId]
    );
    const nextId = (rows[0] ? rows[0].id : 0) + 1;
    return `PUR-${nextId.toString().padStart(6, '0')}`;
  }

  static async findAllByUserId(userId) {
    const [rows] = await db.execute(
      'SELECT * FROM purchases WHERE user_id = ? ORDER BY date DESC, id DESC',
      [userId]
    );
    return rows;
  }

  static async create(userId, data) {
    const connection = await db.getConnection();
    try {
      await connection.beginTransaction();

      const purchaseNum = data.purchase_number || data.purchaseNumber || (await this.generatePurchaseNumber(userId));
      const totalAmount = data.total_amount ?? data.totalAmount ?? 0.00;

      // 1. Insert Purchase
      const [result] = await connection.execute(
        'INSERT INTO purchases (user_id, purchase_number, supplier_name, total_amount, notes) VALUES (?, ?, ?, ?, ?)',
        [userId, purchaseNum, data.supplier_name || data.supplierName || null, totalAmount, data.notes || null]
      );

      const purchaseId = result.insertId;

      // 2. Insert Purchase Items & Increase Product Stock
      if (Array.isArray(data.items)) {
        for (const item of data.items) {
          const productId = item.product_id || item.productId;
          const productName = item.product_name || item.productName;
          const quantity = item.quantity;
          const purchasePrice = item.purchase_price || item.purchasePrice;
          const total = item.total;

          await connection.execute(
            `INSERT INTO purchase_items (
              user_id, purchase_id, product_id, product_name, quantity, purchase_price, total
            ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [userId, purchaseId, productId, productName, quantity, purchasePrice, total]
          );

          // Increase product stock in MySQL
          await connection.execute(
            'UPDATE products SET current_stock = current_stock + ? WHERE user_id = ? AND id = ?',
            [quantity, userId, productId]
          );

          // Record stock movement
          await connection.execute(
            `INSERT INTO stock_movements (
              user_id, product_id, quantity, type, reason, reference_id
            ) VALUES (?, ?, ?, ?, ?, ?)`,
            [userId, productId, quantity, 'Purchase', `Purchase #${purchaseNum}`, purchaseId]
          );
        }
      }

      await connection.commit();
      return { id: purchaseId, purchase_number: purchaseNum, total_amount: totalAmount };
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  }
}

module.exports = PurchaseModel;
