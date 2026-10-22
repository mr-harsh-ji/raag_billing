-- ============================================================================
-- RAAG BILLING SAAS - PRODUCTION MYSQL DATABASE SCHEMA
-- ============================================================================

CREATE DATABASE IF NOT EXISTS raag_billing_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE raag_billing_db;

-- ----------------------------------------------------------------------------
-- 1. USERS TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(20) NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_users_email (email),
  INDEX idx_users_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 2. BUSINESS PROFILES TABLE (1-to-1 with User)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS business_profiles (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL UNIQUE,
  business_name VARCHAR(150) NOT NULL DEFAULT 'My Business',
  owner_name VARCHAR(100) NULL,
  gstin VARCHAR(20) NULL,
  address TEXT NULL,
  phone VARCHAR(20) NULL,
  email VARCHAR(150) NULL,
  logo_url TEXT NULL,
  invoice_prefix VARCHAR(10) NOT NULL DEFAULT 'RB',
  currency_symbol VARCHAR(10) NOT NULL DEFAULT 'Rs',
  upi_id VARCHAR(100) NULL,
  bank_name VARCHAR(100) NULL,
  account_number VARCHAR(50) NULL,
  ifsc_code VARCHAR(20) NULL,
  terms_and_conditions TEXT NULL,
  shop_category VARCHAR(50) DEFAULT 'General',
  default_tax_percentage DECIMAL(5, 2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_business_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 3. CATEGORIES TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_categories_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_categories_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 4. PRODUCTS TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  category_id BIGINT NULL,
  name VARCHAR(150) NOT NULL,
  sku VARCHAR(50) NULL,
  barcode VARCHAR(100) NULL,
  purchase_price DECIMAL(12, 2) DEFAULT 0.00,
  selling_price DECIMAL(12, 2) DEFAULT 0.00,
  tax_percentage DECIMAL(5, 2) DEFAULT 0.00,
  current_stock DECIMAL(12, 3) DEFAULT 0.00,
  minimum_stock DECIMAL(12, 3) DEFAULT 0.00,
  unit VARCHAR(20) DEFAULT 'pcs',
  description TEXT NULL,
  rack_number VARCHAR(50) NULL,
  batch_number VARCHAR(50) NULL,
  hsn_code VARCHAR(30) NULL,
  purity VARCHAR(20) NULL,
  expiry_date DATE NULL,
  manufacturing_date DATE NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
  INDEX idx_products_user (user_id),
  INDEX idx_products_sku (user_id, sku),
  INDEX idx_products_barcode (user_id, barcode),
  INDEX idx_products_name (user_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 5. CUSTOMERS TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(20) NULL,
  email VARCHAR(150) NULL,
  address TEXT NULL,
  opening_balance DECIMAL(12, 2) DEFAULT 0.00,
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_customers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_customers_user (user_id),
  INDEX idx_customers_phone (user_id, phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 6. INVOICES TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS invoices (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  invoice_number VARCHAR(50) NOT NULL,
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  subtotal DECIMAL(12, 2) DEFAULT 0.00,
  tax_amount DECIMAL(12, 2) DEFAULT 0.00,
  cgst DECIMAL(12, 2) DEFAULT 0.00,
  sgst DECIMAL(12, 2) DEFAULT 0.00,
  discount_amount DECIMAL(12, 2) DEFAULT 0.00,
  discount_percentage DECIMAL(5, 2) DEFAULT 0.00,
  round_off DECIMAL(8, 2) DEFAULT 0.00,
  grand_total DECIMAL(12, 2) DEFAULT 0.00,
  paid_amount DECIMAL(12, 2) DEFAULT 0.00,
  due_amount DECIMAL(12, 2) DEFAULT 0.00,
  payment_method VARCHAR(50) DEFAULT 'Cash',
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_invoices_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_invoices_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  UNIQUE KEY uk_user_invoice_number (user_id, invoice_number),
  INDEX idx_invoices_user (user_id),
  INDEX idx_invoices_date (user_id, date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 7. INVOICE ITEMS TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS invoice_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  invoice_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  product_name VARCHAR(150) NOT NULL,
  quantity DECIMAL(12, 3) NOT NULL,
  unit_price DECIMAL(12, 2) NOT NULL,
  tax_percentage DECIMAL(5, 2) DEFAULT 0.00,
  discount_amount DECIMAL(12, 2) DEFAULT 0.00,
  total DECIMAL(12, 2) NOT NULL,
  hsn_code VARCHAR(30) NULL,
  purity VARCHAR(20) NULL,
  gross_weight DECIMAL(10, 3) NULL,
  stone_weight DECIMAL(10, 3) NULL,
  net_weight DECIMAL(10, 3) NULL,
  making_charges DECIMAL(12, 2) NULL,
  rate DECIMAL(12, 2) NULL,
  taxable_value DECIMAL(12, 2) NULL,
  batch_number VARCHAR(50) NULL,
  expiry_date DATE NULL,
  manufacturing_date DATE NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_invoice_items_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_invoice_items_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
  CONSTRAINT fk_invoice_items_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_invoice_items_user (user_id),
  INDEX idx_invoice_items_invoice (invoice_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 8. PAYMENTS TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  invoice_id BIGINT NULL,
  amount DECIMAL(12, 2) NOT NULL,
  method VARCHAR(50) NOT NULL DEFAULT 'Cash',
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_payments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_payments_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  CONSTRAINT fk_payments_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
  INDEX idx_payments_user (user_id),
  INDEX idx_payments_customer (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 9. STOCK MOVEMENTS TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stock_movements (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity DECIMAL(12, 3) NOT NULL,
  type ENUM('Sale', 'Purchase', 'Adjustment', 'Return') NOT NULL,
  reason VARCHAR(255) NULL,
  reference_id BIGINT NULL,
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_stock_movements_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_stock_movements_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_stock_movements_user (user_id),
  INDEX idx_stock_movements_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 10. PURCHASES TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS purchases (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  purchase_number VARCHAR(50) NOT NULL,
  supplier_name VARCHAR(150) NULL,
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(12, 2) NOT NULL,
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_purchases_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uk_user_purchase_number (user_id, purchase_number),
  INDEX idx_purchases_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 11. PURCHASE ITEMS TABLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS purchase_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  purchase_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  product_name VARCHAR(150) NOT NULL,
  quantity DECIMAL(12, 3) NOT NULL,
  purchase_price DECIMAL(12, 2) NOT NULL,
  total DECIMAL(12, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_purchase_items_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_purchase_items_purchase FOREIGN KEY (purchase_id) REFERENCES purchases(id) ON DELETE CASCADE,
  CONSTRAINT fk_purchase_items_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_purchase_items_user (user_id),
  INDEX idx_purchase_items_purchase (purchase_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
