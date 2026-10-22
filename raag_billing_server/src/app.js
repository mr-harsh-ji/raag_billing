const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const authRoutes = require('./routes/auth.routes');
const businessProfileRoutes = require('./routes/business_profile.routes');
const categoryRoutes = require('./routes/category.routes');
const productRoutes = require('./routes/product.routes');
const customerRoutes = require('./routes/customer.routes');
const invoiceRoutes = require('./routes/invoice.routes');
const purchaseRoutes = require('./routes/purchase.routes');
const stockMovementRoutes = require('./routes/stock_movement.routes');
const reportRoutes = require('./routes/report.routes');
const errorHandler = require('./middleware/error.middleware');

const app = express();

// Security Middlewares
app.use(helmet());
app.use(cors({ origin: '*', credentials: true }));

// Body Parser & Request Logger
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// API Health Check
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    data: {
      status: 'online',
      app: 'Raag Billing SaaS Backend',
      version: '1.0.0',
      timestamp: new Date().toISOString(),
    },
  });
});

// SaaS API Routes
app.use('/api/auth', authRoutes);
app.use('/api/business-profile', businessProfileRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/products', productRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/invoices', invoiceRoutes);
app.use('/api/purchases', purchaseRoutes);
app.use('/api/stock-movements', stockMovementRoutes);
app.use('/api/reports', reportRoutes);

// 404 Route Handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route not found: ${req.method} ${req.originalUrl}`,
  });
});

// Global Error Handler Middleware
app.use(errorHandler);

module.exports = app;
