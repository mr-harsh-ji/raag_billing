const bcrypt = require('bcryptjs');
const UserModel = require('../models/user.model');
const { generateToken } = require('../config/jwt');

class AuthService {
  /**
   * Register new user logic
   */
  static async registerUser({ name, email, phone, password }) {
    // 1. Check unique email
    const existingEmail = await UserModel.findByEmail(email);
    if (existingEmail) {
      const error = new Error('Email address is already registered.');
      error.statusCode = 400;
      throw error;
    }

    // 2. Check unique phone (if provided)
    if (phone && phone.trim().length > 0) {
      const existingPhone = await UserModel.findByPhone(phone);
      if (existingPhone) {
        const error = new Error('Phone number is already registered.');
        error.statusCode = 400;
        throw error;
      }
    }

    // 3. Hash password using bcrypt
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    // 4. Create user & default business profile in DB transaction
    const newUser = await UserModel.create({
      name,
      email,
      phone,
      passwordHash,
    });

    // 5. Generate JWT token
    const token = generateToken(newUser);

    return {
      token,
      user: newUser,
    };
  }

  /**
   * Login user logic
   */
  static async loginUser({ identifier, password }) {
    const userWithPassword = await UserModel.findByEmailOrPhone(identifier);
    if (!userWithPassword) {
      const error = new Error('Invalid email/phone or password.');
      error.statusCode = 401;
      throw error;
    }

    if (!userWithPassword.is_active) {
      const error = new Error('Account is deactivated. Please contact support.');
      error.statusCode = 403;
      throw error;
    }

    const isPasswordValid = await bcrypt.compare(password, userWithPassword.password);
    if (!isPasswordValid) {
      const error = new Error('Invalid email/phone or password.');
      error.statusCode = 401;
      throw error;
    }

    const businessProfile = await UserModel.getBusinessProfileByUserId(userWithPassword.id);
    const { password: _, ...user } = userWithPassword;
    const token = generateToken(user);

    return {
      token,
      user,
      businessProfile,
    };
  }
}

module.exports = AuthService;
