const db = require('../config/database');

class ProductModel {
  static async findAllByUserId(userId, { search, category_id, barcode }) {
    let sql = 'SELECT * FROM products WHERE user_id = ?';
    const params = [userId];

    if (barcode && barcode.trim().length > 0) {
      sql += ' AND barcode = ?';
      params.push(barcode.trim());
    } else {
      if (category_id) {
        sql += ' AND category_id = ?';
        params.push(category_id);
      }
      if (search && search.trim().length > 0) {
        sql += ' AND (name LIKE ? OR sku LIKE ? OR barcode LIKE ?)';
        const term = `%${search.trim()}%`;
        params.push(term, term, term);
      }
    }

    sql += ' ORDER BY name ASC';
    const [rows] = await db.execute(sql, params);
    return rows;
  }

  static async findById(userId, productId) {
    const [rows] = await db.execute(
      'SELECT * FROM products WHERE user_id = ? AND id = ?',
      [userId, productId]
    );
    return rows[0] || null;
  }

  static async create(userId, data) {
    const sql = `
      INSERT INTO products (
        user_id, category_id, name, sku, barcode, purchase_price, selling_price,
        tax_percentage, current_stock, minimum_stock, unit, description, rack_number,
        batch_number, hsn_code, purity, expiry_date, manufacturing_date
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const values = [
      userId,
      data.category_id || data.categoryId || null,
      data.name ? data.name.trim() : 'Unnamed Product',
      data.sku ? data.sku.trim() : null,
      data.barcode ? data.barcode.trim() : null,
      data.purchase_price ?? data.purchasePrice ?? 0.00,
      data.selling_price ?? data.sellingPrice ?? 0.00,
      data.tax_percentage ?? data.taxPercentage ?? 0.00,
      data.current_stock ?? data.currentStock ?? 0.00,
      data.minimum_stock ?? data.minimumStock ?? 0.00,
      data.unit || 'pcs',
      data.description ? data.description.trim() : null,
      data.rack_number || data.rackNumber || null,
      data.batch_number || data.batchNumber || null,
      data.hsn_code || data.hsnCode || null,
      data.purity || null,
      (data.expiry_date || data.expiryDate) ? (data.expiry_date || data.expiryDate).toString().substring(0, 10) : null,
      (data.manufacturing_date || data.manufacturingDate) ? (data.manufacturing_date || data.manufacturingDate).toString().substring(0, 10) : null,
    ];

    if (process.env.NODE_ENV === 'development') {
      console.log('📌 [PRODUCT MODEL] SQL Executing:', sql);
      console.log('📌 Values:', values);
    }

    const [result] = await db.execute(sql, values);
    return await this.findById(userId, result.insertId);
  }

  static async update(userId, productId, data) {
    const existing = await this.findById(userId, productId);
    if (!existing) return null;

    const sql = `
      UPDATE products SET
        category_id = ?,
        name = ?,
        sku = ?,
        barcode = ?,
        purchase_price = ?,
        selling_price = ?,
        tax_percentage = ?,
        current_stock = ?,
        minimum_stock = ?,
        unit = ?,
        description = ?,
        rack_number = ?,
        batch_number = ?,
        hsn_code = ?,
        purity = ?,
        expiry_date = ?,
        manufacturing_date = ?,
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ? AND id = ?
    `;

    const values = [
      data.category_id ?? data.categoryId ?? existing.category_id,
      data.name ? data.name.trim() : existing.name,
      data.sku !== undefined ? (data.sku ? data.sku.trim() : null) : existing.sku,
      data.barcode !== undefined ? (data.barcode ? data.barcode.trim() : null) : existing.barcode,
      data.purchase_price ?? data.purchasePrice ?? existing.purchase_price,
      data.selling_price ?? data.sellingPrice ?? existing.selling_price,
      data.tax_percentage ?? data.taxPercentage ?? existing.tax_percentage,
      data.current_stock ?? data.currentStock ?? existing.current_stock,
      data.minimum_stock ?? data.minimumStock ?? existing.minimum_stock,
      data.unit || existing.unit,
      data.description !== undefined ? (data.description ? data.description.trim() : null) : existing.description,
      data.rack_number ?? data.rackNumber ?? existing.rack_number,
      data.batch_number ?? data.batchNumber ?? existing.batch_number,
      data.hsn_code ?? data.hsnCode ?? existing.hsn_code,
      data.purity ?? existing.purity,
      (data.expiry_date || data.expiryDate) ? (data.expiry_date || data.expiryDate).toString().substring(0, 10) : existing.expiry_date,
      (data.manufacturing_date || data.manufacturingDate) ? (data.manufacturing_date || data.manufacturingDate).toString().substring(0, 10) : existing.manufacturing_date,
      userId,
      productId,
    ];

    await db.execute(sql, values);
    return await this.findById(userId, productId);
  }

  static async delete(userId, productId) {
    const [result] = await db.execute(
      'DELETE FROM products WHERE user_id = ? AND id = ?',
      [userId, productId]
    );
    return result.affectedRows > 0;
  }
}

module.exports = ProductModel;
