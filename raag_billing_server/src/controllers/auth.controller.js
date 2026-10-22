const AuthService = require('../services/auth.service');
const UserModel = require('../models/user.model');

/**
 * Register a new user
 * POST /api/auth/register
 */
async function register(req, res, next) {
  try {
    const { name, email, phone, password } = req.body;

    const result = await AuthService.registerUser({
      name,
      email,
      phone,
      password,
    });

    return res.status(201).json({
      success: true,
      data: result,
    });
  } catch (error) {
    if (error.statusCode) {
      return res.status(error.statusCode).json({
        success: false,
        message: error.message,
      });
    }
    next(error);
  }
}

/**
 * Login user via email OR phone
 * POST /api/auth/login
 */
async function login(req, res, next) {
  try {
    const { email_or_phone, email, phone, password } = req.body;
    const identifier = email_or_phone || email || phone;

    if (!identifier) {
      return res.status(400).json({
        success: false,
        message: 'Email or phone number is required.',
      });
    }

    const result = await AuthService.loginUser({
      identifier,
      password,
    });

    return res.json({
      success: true,
      data: result,
    });
  } catch (error) {
    if (error.statusCode) {
      return res.status(error.statusCode).json({
        success: false,
        message: error.message,
      });
    }
    next(error);
  }
}

/**
 * Get current authenticated user profile & business details
 * GET /api/auth/me
 */
async function getMe(req, res, next) {
  try {
    const userId = req.user.id;
    const user = await UserModel.findById(userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User profile not found.',
      });
    }

    const businessProfile = await UserModel.getBusinessProfileByUserId(userId);

    return res.json({
      success: true,
      data: {
        user,
        businessProfile,
      },
    });
  } catch (error) {
    next(error);
  }
}

/**
 * Logout user (Structure only)
 * POST /api/auth/logout
 */
async function logout(req, res) {
  return res.json({
    success: true,
    data: {
      message: 'Logged out successfully.',
    },
  });
}

module.exports = {
  register,
  login,
  getMe,
  logout,
};
