// backend/setup-db.js — Automatic Cloud & Local Database Seeder
const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
require('dotenv').config();

async function setupDatabase() {
  const connectionUrl = process.argv[2] || process.env.MYSQL_URL || process.env.DATABASE_URL;

  let poolConfig;

  if (connectionUrl) {
    console.log('📡 Connecting via connection URL...');
    poolConfig = {
      uri: connectionUrl,
      multipleStatements: true,
      ssl: { rejectUnauthorized: false }
    };
  } else {
    console.log('📡 Connecting to local MySQL server...');
    poolConfig = {
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'ecommerce',
      multipleStatements: true,
      ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : undefined
    };
  }

  try {
    const connection = await mysql.createConnection(poolConfig);
    console.log('✅ Connected to database successfully.');

    const sqlPath = path.join(__dirname, 'database.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');

    console.log('⏳ Executing database schema and seed data...');
    await connection.query(sql);

    console.log('🎉 Database setup complete! All tables and sample products created successfully.');
    await connection.end();
    process.exit(0);
  } catch (err) {
    console.error('❌ Database setup failed:', err.message);
    process.exit(1);
  }
}

setupDatabase();
