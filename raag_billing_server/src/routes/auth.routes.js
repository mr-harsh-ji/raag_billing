const express = require('express');
const { body } = require('express-validator');
const router = express.Router();

const authController = require('../controllers/auth.controller');
const authenticateToken = require('../middleware/auth.middleware');
const validate = require('../middleware/validator.middleware');

// Registration Validations
const registerValidations = [
  body('name')
    .trim()
    .notEmpty()
    .withMessage('Name is required.'),
  body('email')
    .trim()
    .isEmail()
    .withMessage('A valid email address is required.'),
  body('password')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters long.'),
  body('phone')
    .optional({ checkFalsy: true })
    .trim(),
  validate,
];

// Login Validations
const loginValidations = [
  body('password')
    .notEmpty()
    .withMessage('Password is required.'),
  validate,
];

// Public Auth Endpoints
router.post('/register', registerValidations, authController.register);
router.post('/login', loginValidations, authController.login);
router.post('/logout', authController.logout);

// Protected Auth Endpoint
router.get('/me', authenticateToken, authController.getMe);

module.exports = router;
