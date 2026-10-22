const db = require('../config/database');

class UserModel {
  /**
   * Find user by email
   */
  static async findByEmail(email) {
    if (!email) return null;
    const cleanEmail = email.toLowerCase().trim();
    const [rows] = await db.execute('SELECT * FROM users WHERE LOWER(email) = ?', [cleanEmail]);
    return rows[0] || null;
  }

  /**
   * Find user by phone number
   */
  static async findByPhone(phone) {
    if (!phone || phone.trim().length === 0) return null;
    const cleanPhone = phone.trim();
    const [rows] = await db.execute('SELECT * FROM users WHERE phone = ?', [cleanPhone]);
    return rows[0] || null;
  }

  /**
   * Find user by email or phone number
   */
  static async findByEmailOrPhone(identifier) {
    if (!identifier) return null;
    const cleanIdentifier = identifier.toLowerCase().trim();
    const query = 'SELECT * FROM users WHERE LOWER(email) = ? OR phone = ?';
    const [rows] = await db.execute(query, [cleanIdentifier, cleanIdentifier]);
    return rows[0] || null;
  }

  /**
   * Find user by ID without returning password
   */
  static async findById(id) {
    const query = `
      SELECT id, name, email, phone, is_active, created_at, updated_at
      FROM users WHERE id = ?
    `;
    const [rows] = await db.execute(query, [id]);
    return rows[0] || null;
  }

  /**
   * Fetch Business Profile for a given user ID
   */
  static async getBusinessProfileByUserId(userId) {
    const query = `
      SELECT id, user_id, business_name, owner_name, gstin, address, phone, email,
             logo_url, invoice_prefix, currency_symbol, upi_id, bank_name,
             account_number, ifsc_code, terms_and_conditions, shop_category,
             default_tax_percentage, created_at, updated_at
      FROM business_profiles WHERE user_id = ?
      LIMIT 1
    `;
    const [rows] = await db.execute(query, [userId]);
    return rows[0] || null;
  }

  /**
   * Create a new User and automatically create default Business Profile in SQL transaction
   */
  static async create({ name, email, phone, passwordHash }) {
    const connection = await db.getConnection();
    try {
      await connection.beginTransaction();

      const cleanName = name ? name.trim() : '';
      const cleanEmail = email ? email.toLowerCase().trim() : '';
      const cleanPhone = (phone && phone.trim().length > 0) ? phone.trim() : null;

      // 1. Insert User (4 placeholders -> 4 values)
      const userSql = 'INSERT INTO users (name, email, phone, password) VALUES (?, ?, ?, ?)';
      const userValues = [cleanName, cleanEmail, cleanPhone, passwordHash];

      if (process.env.NODE_ENV === 'development') {
        console.log('📌 Executing SQL:', userSql);
        console.log('📌 Values:', userValues);
      }

      const [userResult] = await connection.execute(userSql, userValues);
      const userId = userResult.insertId;

      // 2. Automatically Create Business Profile for User (5 placeholders -> 5 values)
      const profileSql = `INSERT INTO business_profiles
        (user_id, business_name, owner_name, email, phone)
       VALUES (?, ?, ?, ?, ?)`;
      const profileValues = [userId, `${cleanName}'s Business`, cleanName, cleanEmail, cleanPhone];

      if (process.env.NODE_ENV === 'development') {
        console.log('📌 Executing SQL:', profileSql);
        console.log('📌 Values:', profileValues);
      }

      await connection.execute(profileSql, profileValues);

      await connection.commit();

      // Return sanitized user object
      return {
        id: userId,
        name: cleanName,
        email: cleanEmail,
        phone: cleanPhone,
      };
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  }
}

module.exports = UserModel;
