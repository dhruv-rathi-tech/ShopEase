-- ============================================================
-- ShopEase — E-COMMERCE DATABASE SETUP
-- Compatible with Local MySQL, Railway, TiDB Cloud, and Aiven
-- ============================================================

-- If creating a new local database, uncomment the next two lines:
-- CREATE DATABASE IF NOT EXISTS ecommerce;
-- USE ecommerce;

-- ── USERS ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100) NOT NULL,
  email        VARCHAR(100) NOT NULL UNIQUE,
  password     VARCHAR(255) NOT NULL,
  role         ENUM('customer', 'admin') DEFAULT 'customer',
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── CATEGORIES ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100) NOT NULL,
  parent_id    INT DEFAULT NULL,
  FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- ── PRODUCTS ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(200) NOT NULL,
  description  TEXT,
  price        DECIMAL(10,2) NOT NULL,
  stock        INT NOT NULL DEFAULT 0,
  image_url    VARCHAR(500),
  category_id  INT,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- ── CART ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cart (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT NOT NULL,
  product_id   INT NOT NULL,
  quantity     INT NOT NULL DEFAULT 1,
  FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ── ORDERS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  user_id             INT NOT NULL,
  total               DECIMAL(10,2) NOT NULL,
  status              ENUM('pending','confirmed','shipped','delivered','cancelled') DEFAULT 'pending',
  payment_status      ENUM('unpaid','paid','refunded','refund_initiated') DEFAULT 'unpaid',
  razorpay_order_id   VARCHAR(100),
  razorpay_payment_id VARCHAR(100),
  created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ── ORDER ITEMS ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  order_id    INT NOT NULL,
  product_id  INT NOT NULL,
  quantity    INT NOT NULL,
  price       DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id)   REFERENCES orders(id)   ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ── SAMPLE DATA (Inserted only if not already existing) ─────

-- Categories
INSERT IGNORE INTO categories (id, name, parent_id) VALUES
  (1, 'Electronics', NULL),
  (2, 'Fashion', NULL),
  (3, 'Mobiles', 1),
  (4, 'Laptops', 1),
  (5, 'Men''s Clothing', 2),
  (6, 'Women''s Clothing', 2);

-- Products
INSERT IGNORE INTO products (id, name, description, price, stock, category_id) VALUES
  (1, 'iPhone 14', 'Apple smartphone 128GB - Super Retina XDR display', 79999.00, 50, 3),
  (2, 'Samsung Galaxy S23', 'Android flagship phone - Dynamic AMOLED 2X', 69999.00, 40, 3),
  (3, 'Dell Inspiron 15', 'Core i5 laptop 8GB RAM 512GB SSD', 55000.00, 20, 4),
  (4, 'Men''s T-Shirt', '100% Premium Cotton Round Neck T-shirt', 499.00, 100, 5),
  (5, 'Women''s Kurti', 'Floral print cotton ethnic kurti', 799.00, 80, 6);

-- Admin user (email: admin@shop.com | password: password)
INSERT IGNORE INTO users (id, name, email, password, role) VALUES
  (1, 'Admin', 'admin@shop.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');