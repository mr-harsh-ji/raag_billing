require('dotenv').config();
const app = require('./app');
const initializeDatabase = require('./database/init_db');

const PORT = process.env.PORT || 5000;

async function startServer() {
  try {
    // 1. Auto-initialize Database Schema if needed
    await initializeDatabase();

    // 2. Start Express HTTP Server
    app.listen(PORT, '0.0.0.0', () => {
      console.log('====================================================');
      console.log(`🚀 Raag Billing SaaS Backend Server RUNNING`);
      console.log(`📡 Listening on: http://0.0.0.0:${PORT}`);
      console.log(`⚙️  Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log('====================================================');
    });
  } catch (error) {
    console.error('💥 Fatal Server Startup Error:', error);
    process.exit(1);
  }
}

startServer();
