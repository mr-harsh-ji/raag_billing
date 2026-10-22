const db = require('../config/database');

async function getReportSummary(req, res, next) {
  try {
    const userId = req.user.id;
    const todayStr = new Date().toISOString().substring(0, 10);

    // 1. Today's Invoices Summary
    const [todayRows] = await db.execute(
      `SELECT
        COUNT(id) AS todayInvoicesCount,
        COALESCE(SUM(grand_total), 0.00) AS todayTotalSales,
        COALESCE(SUM(paid_amount), 0.00) AS todayPaidRevenue
       FROM invoices
       WHERE user_id = ? AND DATE(date) = ?`,
      [userId, todayStr]
    );

    // 2. Total Pending Dues across all invoices
    const [duesRows] = await db.execute(
      'SELECT COALESCE(SUM(due_amount), 0.00) AS totalPendingDues FROM invoices WHERE user_id = ?',
      [userId]
    );

    // 3. Counts: Total Products, Total Customers, Low Stock Count
    const [prodCountRows] = await db.execute(
      'SELECT COUNT(id) AS totalProducts FROM products WHERE user_id = ?',
      [userId]
    );

    const [lowStockRows] = await db.execute(
      'SELECT COUNT(id) AS lowStockCount FROM products WHERE user_id = ? AND current_stock <= minimum_stock',
      [userId]
    );

    const [custCountRows] = await db.execute(
      'SELECT COUNT(id) AS totalCustomers FROM customers WHERE user_id = ?',
      [userId]
    );

    const summary = {
      todayInvoicesCount: todayRows[0]?.todayInvoicesCount || 0,
      todayTotalSales: parseFloat(todayRows[0]?.todayTotalSales || 0),
      todayPaidRevenue: parseFloat(todayRows[0]?.todayPaidRevenue || 0),
      totalPendingDues: parseFloat(duesRows[0]?.totalPendingDues || 0),
      totalProducts: prodCountRows[0]?.totalProducts || 0,
      lowStockCount: lowStockRows[0]?.lowStockCount || 0,
      totalCustomers: custCountRows[0]?.totalCustomers || 0,
    };

    return res.json({ success: true, data: summary });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getReportSummary,
};
