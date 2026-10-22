const db = require('../config/database');

class InvoiceModel {
  static async generateInvoiceNumber(userId) {
    const [rows] = await db.execute(
      'SELECT id FROM invoices WHERE user_id = ? ORDER BY id DESC LIMIT 1',
      [userId]
    );

    const [profile] = await db.execute(
      'SELECT invoice_prefix FROM business_profiles WHERE user_id = ? LIMIT 1',
      [userId]
    );

    const prefix = (profile[0] && profile[0].invoice_prefix) ? profile[0].invoice_prefix : 'RB';
    const nextId = (rows[0] ? rows[0].id : 0) + 1;
    return `${prefix}-${nextId.toString().padStart(6, '0')}`;
  }

  static async findAllByUserId(userId) {
    const [rows] = await db.execute(
      'SELECT * FROM invoices WHERE user_id = ? ORDER BY date DESC, id DESC',
      [userId]
    );
    return rows;
  }

  static async findById(userId, invoiceId) {
    const [invoices] = await db.execute(
      'SELECT * FROM invoices WHERE user_id = ? AND id = ?',
      [userId, invoiceId]
    );
    if (!invoices[0]) return null;

    const [items] = await db.execute(
      'SELECT * FROM invoice_items WHERE user_id = ? AND invoice_id = ?',
      [userId, invoiceId]
    );

    const invoice = invoices[0];
    invoice.items = items;
    return invoice;
  }

  static async create(userId, data) {
    const connection = await db.getConnection();
    try {
      await connection.beginTransaction();

      const invoiceNum = data.invoice_number || data.invoiceNumber || (await this.generateInvoiceNumber(userId));
      let validCustomerId = data.customer_id || data.customerId;

      // 1. Ensure customerId exists in MySQL customers table for this user
      if (validCustomerId) {
        const [custRows] = await connection.execute(
          'SELECT id FROM customers WHERE user_id = ? AND id = ?',
          [userId, validCustomerId]
        );
        if (custRows.length === 0) {
          validCustomerId = null;
        }
      }

      // If customerId is missing or doesn't exist in MySQL, find or create default Walk-in Customer
      if (!validCustomerId) {
        const [defaultCust] = await connection.execute(
          'SELECT id FROM customers WHERE user_id = ? ORDER BY id ASC LIMIT 1',
          [userId]
        );
        if (defaultCust.length > 0) {
          validCustomerId = defaultCust[0].id;
        } else {
          // Create default Walk-in Customer for this user in MySQL
          const [newCust] = await connection.execute(
            'INSERT INTO customers (user_id, name, phone) VALUES (?, ?, ?)',
            [userId, 'Walk-in Customer', '0000000000']
          );
          validCustomerId = newCust.insertId;
        }
      }

      const subtotal = data.subtotal ?? 0.00;
      const taxAmount = data.tax_amount ?? data.taxAmount ?? 0.00;
      const discountAmount = data.discount_amount ?? data.discountAmount ?? 0.00;
      const grandTotal = data.grand_total ?? data.grandTotal ?? 0.00;
      const paidAmount = data.paid_amount ?? data.paidAmount ?? grandTotal;
      const dueAmount = data.due_amount ?? data.dueAmount ?? (grandTotal - paidAmount);
      const paymentMethod = data.payment_method || data.paymentMethod || 'Cash';

      // 2. Insert Invoice
      const [invoiceResult] = await connection.execute(
        `INSERT INTO invoices (
          user_id, customer_id, invoice_number, subtotal, tax_amount, cgst, sgst,
          discount_amount, discount_percentage, round_off, grand_total, paid_amount,
          due_amount, payment_method, notes
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          userId,
          validCustomerId,
          invoiceNum,
          subtotal,
          taxAmount,
          data.cgst ?? 0.00,
          data.sgst ?? 0.00,
          discountAmount,
          data.discount_percentage ?? data.discountPercentage ?? 0.00,
          data.round_off ?? data.roundOff ?? 0.00,
          grandTotal,
          paidAmount,
          dueAmount,
          paymentMethod,
          data.notes || null,
        ]
      );

      const invoiceId = invoiceResult.insertId;

      // 3. Insert Invoice Items & Update Stock Inventory
      if (Array.isArray(data.items)) {
        for (const item of data.items) {
          let productId = item.product_id || item.productId;
          const productName = item.product_name || item.productName || 'Item';
          const quantity = item.quantity || 1;
          const unitPrice = item.unit_price || item.unitPrice || 0.00;
          const total = item.total || (quantity * unitPrice);

          // Ensure product exists in MySQL products table for this user
          if (!productId || productId <= 0) {
            const [newProd] = await connection.execute(
              'INSERT INTO products (user_id, name, selling_price, current_stock) VALUES (?, ?, ?, ?)',
              [userId, productName, unitPrice, 100.00]
            );
            productId = newProd.insertId;
          } else {
            const [prodRows] = await connection.execute(
              'SELECT id FROM products WHERE user_id = ? AND id = ?',
              [userId, productId]
            );
            if (prodRows.length === 0) {
              const [newProd] = await connection.execute(
                'INSERT INTO products (user_id, name, selling_price, current_stock) VALUES (?, ?, ?, ?)',
                [userId, productName, unitPrice, 100.00]
              );
              productId = newProd.insertId;
            }
          }

          await connection.execute(
            `INSERT INTO invoice_items (
              user_id, invoice_id, product_id, product_name, quantity, unit_price,
              tax_percentage, discount_amount, total, hsn_code, purity, batch_number
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
              userId,
              invoiceId,
              productId,
              productName,
              quantity,
              unitPrice,
              item.tax_percentage ?? item.taxPercentage ?? 0.00,
              item.discount_amount ?? item.discountAmount ?? 0.00,
              total,
              item.hsn_code || item.hsnCode || null,
              item.purity || null,
              item.batch_number || item.batchNumber || null,
            ]
          );

          // Decrease product stock in MySQL
          await connection.execute(
            'UPDATE products SET current_stock = current_stock - ? WHERE user_id = ? AND id = ?',
            [quantity, userId, productId]
          );

          // Record stock movement
          await connection.execute(
            `INSERT INTO stock_movements (
              user_id, product_id, quantity, type, reason, reference_id
            ) VALUES (?, ?, ?, ?, ?, ?)`,
            [userId, productId, -quantity, 'Sale', `Invoice #${invoiceNum}`, invoiceId]
          );
        }
      }

      await connection.commit();
      return await this.findById(userId, invoiceId);
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  }
}

module.exports = InvoiceModel;
