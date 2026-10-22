const db = require('../config/database');

class BusinessProfileModel {
  /**
   * Find business profile by user_id
   */
  static async findByUserId(userId) {
    const [rows] = await db.execute(
      'SELECT * FROM business_profiles WHERE user_id = ? LIMIT 1',
      [userId]
    );
    return rows[0] || null;
  }

  /**
   * Create or update business profile for a user
   */
  static async upsert(userId, profileData) {
    const existing = await this.findByUserId(userId);

    const {
      business_name,
      owner_name,
      gstin,
      address,
      phone,
      email,
      logo_url,
      invoice_prefix,
      currency_symbol,
      upi_id,
      bank_name,
      account_number,
      ifsc_code,
      terms_and_conditions,
      shop_category,
      default_tax_percentage,
    } = profileData;

    if (existing) {
      const sql = `
        UPDATE business_profiles SET
          business_name = ?,
          owner_name = ?,
          gstin = ?,
          address = ?,
          phone = ?,
          email = ?,
          logo_url = ?,
          invoice_prefix = ?,
          currency_symbol = ?,
          upi_id = ?,
          bank_name = ?,
          account_number = ?,
          ifsc_code = ?,
          terms_and_conditions = ?,
          shop_category = ?,
          default_tax_percentage = ?,
          updated_at = CURRENT_TIMESTAMP
        WHERE user_id = ?
      `;

      const values = [
        business_name || existing.business_name || 'My Business',
        owner_name ?? existing.owner_name,
        gstin ?? existing.gstin,
        address ?? existing.address,
        phone ?? existing.phone,
        email ?? existing.email,
        logo_url ?? existing.logo_url,
        invoice_prefix || existing.invoice_prefix || 'RB',
        currency_symbol || existing.currency_symbol || 'Rs',
        upi_id ?? existing.upi_id,
        bank_name ?? existing.bank_name,
        account_number ?? existing.account_number,
        ifsc_code ?? existing.ifsc_code,
        terms_and_conditions ?? existing.terms_and_conditions,
        shop_category || existing.shop_category || 'General',
        default_tax_percentage ?? existing.default_tax_percentage ?? 0.00,
        userId,
      ];

      await db.execute(sql, values);
    } else {
      const sql = `
        INSERT INTO business_profiles (
          user_id, business_name, owner_name, gstin, address, phone, email,
          logo_url, invoice_prefix, currency_symbol, upi_id, bank_name,
          account_number, ifsc_code, terms_and_conditions, shop_category,
          default_tax_percentage
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;

      const values = [
        userId,
        business_name || 'My Business',
        owner_name || null,
        gstin || null,
        address || null,
        phone || null,
        email || null,
        logo_url || null,
        invoice_prefix || 'RB',
        currency_symbol || 'Rs',
        upi_id || null,
        bank_name || null,
        account_number || null,
        ifsc_code || null,
        terms_and_conditions || null,
        shop_category || 'General',
        default_tax_percentage || 0.00,
      ];

      await db.execute(sql, values);
    }

    return await this.findByUserId(userId);
  }
}

module.exports = BusinessProfileModel;
