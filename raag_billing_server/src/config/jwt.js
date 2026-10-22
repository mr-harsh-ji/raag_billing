const jwt = require('jsonwebtoken');
require('dotenv').config();

const JWT_SECRET = process.env.JWT_SECRET || 'fallback_secret_key_change_me';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';

/**
 * Generate a JWT token for an authenticated user.
 * @param {Object} payload - User object containing id, email, phone, name
 * @returns {String} Signed JWT token
 */
function generateToken(payload) {
  return jwt.sign(
    {
      id: payload.id,
      email: payload.email,
      phone: payload.phone,
      name: payload.name,
    },
    JWT_SECRET,
    { expiresIn: JWT_EXPIRES_IN }
  );
}

/**
 * Verify a JWT token.
 * @param {String} token - Bearer JWT token
 * @returns {Object} Decoded token payload
 */
function verifyToken(token) {
  return jwt.verify(token, JWT_SECRET);
}

module.exports = {
  generateToken,
  verifyToken,
};
