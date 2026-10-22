const db = require('../config/database');

async function getStockMovements(req, res, next) {
  try {
    const userId = req.user.id;
    const { product_id } = req.query;

    let sql = 'SELECT * FROM stock_movements WHERE user_id = ?';
    const params = [userId];

    if (product_id) {
      sql += ' AND product_id = ?';
      params.push(product_id);
    }

    sql += ' ORDER BY date DESC, id DESC';

    const [rows] = await db.execute(sql, params);
    return res.json({ success: true, count: rows.length, data: rows });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getStockMovements,
};
