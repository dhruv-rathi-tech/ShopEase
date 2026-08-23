const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
require('dotenv').config();

const express = require('express');
const cors = require('cors');

const app = express();

// ── MIDDLEWARE ─────────────────────────────────────────────
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ── SERVE STATIC FRONTEND ──────────────────────────────────
const frontendPath = path.join(__dirname, '../frontend');
app.use(express.static(frontendPath));

// ── API ROUTES ─────────────────────────────────────────────
app.use('/auth',       require('./routes/auth'));
app.use('/categories', require('./routes/categories'));
app.use('/products',   require('./routes/products'));
app.use('/cart',       require('./routes/cart'));
app.use('/orders',     require('./routes/orders'));
app.use('/payments',   require('./routes/payments'));

// ── HEALTH CHECK ───────────────────────────────────────────
app.get(['/api', '/api/health'], (req, res) => {
  res.json({
    status: 'ok',
    message: '🛒 ShopEase API is running!',
    timestamp: new Date().toISOString()
  });
});

// ── FRONTEND ROUTING FALLBACK ──────────────────────────────
// For any non-API GET request, fallback to frontend
app.get('*', (req, res, next) => {
  // If requesting an API route that wasn't found, skip to 404
  if (req.path.startsWith('/auth') || 
      req.path.startsWith('/categories') || 
      req.path.startsWith('/products') || 
      req.path.startsWith('/cart') || 
      req.path.startsWith('/orders') || 
      req.path.startsWith('/payments') ||
      req.path.startsWith('/api')) {
    return next();
  }
  res.sendFile(path.join(frontendPath, 'index.html'));
});

// ── 404 API HANDLER ────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found.' });
});

// ── GLOBAL ERROR HANDLER ───────────────────────────────────
app.use((err, req, res, next) => {
  console.error('Unhandled server error:', err);
  res.status(500).json({ error: 'Internal Server Error.' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ ShopEase Server running at http://localhost:${PORT}`);
});