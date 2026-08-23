# ShopEase 🛒 — Full-Stack E-Commerce Platform

A production-ready full-stack e-commerce web application built with **Node.js**, **Express**, **MySQL**, and vanilla **HTML5 / Modern CSS / JavaScript**.

---

## Features

### 🛍️ Customer Experience
- **User Authentication**: Secure signup and login with JWT & bcrypt password hashing.
- **Product Catalog**: Dynamic product feed with live search and category/subcategory filtering.
- **Cart Management**: Add to cart, real-time quantity adjustment, subtotal/total calculations, and item removal.
- **Direct Checkout / Buy Now**: Seamless order creation with stock validation.
- **Online Payments**: Integrated with **Razorpay** popup checkout and backend cryptographic signature verification.
- **Order Tracking & History**: View confirmed orders and item breakdowns with a 24-hour cancellation window (including automated stock restock and refund initiation).

### Admin Experience
- **Role-Based Access Control (RBAC)**: Admin-only API protection.
- **Inventory Management**: Create new products, update catalog details, and delete items.
- **Order Management**: View all customer orders and update shipping/delivery statuses.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Node.js (v18+), Express.js |
| **Database** | MySQL (with connection pooling & SSL support) |
| **Authentication** | JWT (JSON Web Tokens), bcrypt |
| **Payment Gateway** | Razorpay (Test / Live modes) |
| **Frontend** | Modern Vanilla HTML5, CSS3 (Glassmorphic dark aesthetic), Vanilla JS (ES6+) |
| **Deployment** | Railway.app / Render / Vercel |

---

## 📁 Project Structure

```
ShopEase/
├── backend/
│   ├── config/
│   │   └── db.js              # MySQL connection pool (Local & Cloud/Railway/SSL)
│   ├── middleware/
│   │   └── auth.js            # JWT auth & admin protection middleware
│   ├── routes/
│   │   ├── auth.js            # /auth (Register, Login, Me)
│   │   ├── categories.js      # /categories (Categories & Subcategories)
│   │   ├── products.js        # /products (CRUD products)
│   │   ├── cart.js            # /cart (Cart operations)
│   │   ├── orders.js          # /orders (Checkout, Orders, Status)
│   │   └── payments.js        # /payments (Razorpay create & verify)
│   ├── database.sql           # Database schema & sample seed data
│   ├── package.json           # Backend package configuration
│   └── server.js              # Express app entry & static frontend server
├── frontend/
│   ├── js/
│   │   └── config.js          # Dynamic API URL resolution (Dev vs Production)
│   ├── index.html             # Smart entry point with auth-based routing
│   ├── login.html             # Login portal
│   ├── register.html          # Registration portal
│   ├── products.html          # Product storefront & admin inventory modal
│   ├── cart.html              # Shopping cart & Razorpay checkout
│   └── orders.html            # Order history & admin order management
├── .env.example               # Environment variables template
├── .gitignore                 # Git ignore rules
├── railway.json               # Railway deployment configuration
├── package.json               # Root orchestration package
└── README.md
```

---

## Quick Start (Local Development)

### 1. Prerequisites
- [Node.js](https://nodejs.org/) (v18 or higher)
- [MySQL](https://www.mysql.com/) server (Local or Cloud)
- Free [Razorpay](https://razorpay.com/) account (Test mode)

### 2. Installation
```bash
# Clone the repository
git clone https://github.com/dhruv-rathi-tech/ecommerce_web.git
cd ShopEase

# Install dependencies
npm install
```

### 3. Database Setup
1. Open your MySQL client (MySQL Workbench, TablePlus, or CLI).
2. Execute the queries inside `backend/database.sql` to initialize all tables and seed sample data.

### 4. Configure Environment Variables
Create a `.env` file in the root directory (refer to `.env.example`):
```env
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=ecommerce
DB_SSL=false
JWT_SECRET=your_super_secret_jwt_key
RAZORPAY_KEY_ID=rzp_test_your_key_id
RAZORPAY_KEY_SECRET=your_razorpay_secret_key
```

### 5. Start the Application
```bash
npm start
```
Visit **`http://localhost:3000`** in your browser. The backend will automatically serve both the API and the frontend!

---

## Deployment Guide (Railway.app — Recommended)

Deploying to **Railway** provides an all-in-one setup with a managed MySQL database and zero cold starts.

### Step 1: Push to GitHub
Ensure all your files are committed and pushed to your GitHub repository.

### Step 2: Create Railway Project
1. Log in to [Railway.app](https://railway.app).
2. Click **+ New Project** -> **Deploy from GitHub repo** -> Select your `ShopEase` repository.
3. Click **+ New** inside your project -> **Database** -> **Add MySQL**.

### Step 3: Connect Database & Configure Variables
1. Click on your **Web Service** in Railway -> Go to the **Variables** tab.
2. Click **Add Reference** to link the MySQL service variables, or add:
   - `DATABASE_URL`: `${{MySQL.DATABASE_URL}}` *(Railway automatically fills this)*
   - `JWT_SECRET`: `<any-strong-random-string>`
   - `RAZORPAY_KEY_ID`: `<your-razorpay-key-id>`
   - `RAZORPAY_KEY_SECRET`: `<your-razorpay-secret-key>`
3. Go to the **Settings** tab -> Under **Networking**, click **Generate Domain** (e.g. `https://shopease-production.up.railway.app`).

### Step 4: Import Database Schema into Railway MySQL
1. In Railway, click on your **MySQL** service.
2. Go to the **Data** or **Connect** tab.
3. Connect via MySQL Workbench / TablePlus using the public connection details, or copy the contents of `backend/database.sql` and run it via the Query editor.

**Your full-stack application is now live!**

---

## Test Payment Card (Razorpay Sandbox)
```
Card Number : 5267 3181 8797 5449
Expiry      : 12/28
CVV         : 123
OTP         : 1234
```

---

## API Reference

### Authentication (`/auth`)
- `POST /auth/register` — Create a new customer account
- `POST /auth/login` — Login and receive JWT token
- `GET  /auth/me` — Retrieve logged-in user profile

### Products (`/products`)
- `GET    /products` — List all products (supports `?search=` and `?category=`)
- `GET    /products/:id` — Get single product
- `POST   /products` — Add product *(Admin only)*
- `PUT    /products/:id` — Update product *(Admin only)*
- `DELETE /products/:id` — Remove product *(Admin only)*

### Categories (`/categories`)
- `GET  /categories` — Get full category tree with subcategories

### Cart (`/cart`)
- `GET    /cart` — View user's cart
- `POST   /cart/add` — Add product to cart
- `PUT    /cart/update` — Update item quantity
- `DELETE /cart/remove/:cart_item_id` — Remove item from cart
- `DELETE /cart/clear` — Clear entire cart

### Orders (`/orders`)
- `POST /orders/checkout` — Place order from current cart
- `POST /orders/buy-now` — Single-product instant order
- `GET  /orders/my` — View logged-in user's paid orders
- `GET  /orders/:id` — View order details
- `POST /orders/:id/cancel` — Cancel order within 24 hours (triggers restock + refund)
- `GET  /orders/admin/all` — View all store orders *(Admin only)*
- `PUT  /orders/:id/status` — Update order status *(Admin only)*

### Payments (`/payments`)
- `POST /payments/create` — Create Razorpay payment order
- `POST /payments/verify` — Verify cryptographic payment signature & deduct inventory stock
- `GET  /payments/status/:order_id` — Check payment status

---

## 👤 Author
**Dhruv Rathi**
- GitHub: [@dhruv-rathi-tech](https://github.com/dhruv-rathi-tech)
- LinkedIn: [dhruv-rathi-31dr](https://www.linkedin.com/in/dhruv-rathi-31dr)
