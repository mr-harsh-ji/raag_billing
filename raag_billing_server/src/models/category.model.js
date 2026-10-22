const db = require('../config/database');

class CategoryModel {
  static async findAllByUserId(userId) {
    const [rows] = await db.execute(
      'SELECT * FROM categories WHERE user_id = ? ORDER BY name ASC',
      [userId]
    );
    return rows;
  }

  static async findById(userId, categoryId) {
    const [rows] = await db.execute(
      'SELECT * FROM categories WHERE user_id = ? AND id = ?',
      [userId, categoryId]
    );
    return rows[0] || null;
  }

  static async create(userId, { name, description }) {
    const cleanName = name.trim();
    const [existing] = await db.execute(
      'SELECT * FROM categories WHERE user_id = ? AND LOWER(name) = ? LIMIT 1',
      [userId, cleanName.toLowerCase()]
    );
    if (existing.length > 0) {
      return existing[0];
    }

    const [result] = await db.execute(
      'INSERT INTO categories (user_id, name, description) VALUES (?, ?, ?)',
      [userId, cleanName, description ? description.trim() : null]
    );
    return await this.findById(userId, result.insertId);
  }

  static async update(userId, categoryId, { name, description }) {
    await db.execute(
      'UPDATE categories SET name = ?, description = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ? AND id = ?',
      [name.trim(), description ? description.trim() : null, userId, categoryId]
    );
    return await this.findById(userId, categoryId);
  }

  static async delete(userId, categoryId) {
    const [result] = await db.execute(
      'DELETE FROM categories WHERE user_id = ? AND id = ?',
      [userId, categoryId]
    );
    return result.affectedRows > 0;
  }
}

module.exports = CategoryModel;
