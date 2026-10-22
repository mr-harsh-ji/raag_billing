const { verifyToken } = require('../config/jwt');

/**
 * JWT Authentication Middleware
 * Protects endpoints and attaches authenticated user info to req.user
 */
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'] || req.headers['Authorization'];
  const token = authHeader && authHeader.startsWith('Bearer ') ? authHeader.split(' ')[1] : null;

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Access denied. No token provided.',
    });
  }

  try {
    const decoded = verifyToken(token);
    req.user = decoded; // Contains id, email, phone, name
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: 'Token has expired. Please login again.',
      });
    }
    return res.status(401).json({
      success: false,
      message: 'Invalid or corrupt token.',
    });
  }
}

module.exports = authenticateToken;
