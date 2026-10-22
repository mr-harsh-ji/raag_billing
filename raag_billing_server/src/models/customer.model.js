const db = require('../config/database');

class CustomerModel {
  static async findAllByUserId(userId, search) {
    let sql = 'SELECT * FROM customers WHERE user_id = ?';
    const params = [userId];

    if (search && search.trim().length > 0) {
      sql += ' AND (name LIKE ? OR phone LIKE ? OR email LIKE ?)';
      const term = `%${search.trim()}%`;
      params.push(term, term, term);
    }

    sql += ' ORDER BY name ASC';
    const [rows] = await db.execute(sql, params);
    return rows;
  }

  static async findById(userId, customerId) {
    const [rows] = await db.execute(
      'SELECT * FROM customers WHERE user_id = ? AND id = ?',
      [userId, customerId]
    );
    return rows[0] || null;
  }

  static async create(userId, data) {
    const sql = `
      INSERT INTO customers (
        user_id, name, phone, email, address, opening_balance, notes
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
    `;

    const values = [
      userId,
      data.name.trim(),
      data.phone ? data.phone.trim() : null,
      data.email ? data.email.trim() : null,
      data.address ? data.address.trim() : null,
      data.opening_balance ?? data.openingBalance ?? 0.00,
      data.notes ? data.notes.trim() : null,
    ];

    const [result] = await db.execute(sql, values);
    return await this.findById(userId, result.insertId);
  }

  static async update(userId, customerId, data) {
    const existing = await this.findById(userId, customerId);
    if (!existing) return null;

    const sql = `
      UPDATE customers SET
        name = ?,
        phone = ?,
        email = ?,
        address = ?,
        opening_balance = ?,
        notes = ?,
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ? AND id = ?
    `;

    const values = [
      data.name ? data.name.trim() : existing.name,
      data.phone !== undefined ? (data.phone ? data.phone.trim() : null) : existing.phone,
      data.email !== undefined ? (data.email ? data.email.trim() : null) : existing.email,
      data.address !== undefined ? (data.address ? data.address.trim() : null) : existing.address,
      data.opening_balance ?? data.openingBalance ?? existing.opening_balance,
      data.notes !== undefined ? (data.notes ? data.notes.trim() : null) : existing.notes,
      userId,
      customerId,
    ];

    await db.execute(sql, values);
    return await this.findById(userId, customerId);
  }

  static async delete(userId, customerId) {
    const [result] = await db.execute(
      'DELETE FROM customers WHERE user_id = ? AND id = ?',
      [userId, customerId]
    );
    return result.affectedRows > 0;
  }
}

module.exports = CustomerModel;
