const bcrypt = require('bcryptjs');
const { User } = require('../models');
const JWTUtil = require('../utils/jwt.util');
require('dotenv').config();

// Validate required environment variables
const requiredAuthVars = ['JWT_SECRET', 'JWT_REFRESH_SECRET'];
const missingAuthVars = requiredAuthVars.filter(varName => !process.env[varName]);

if (missingAuthVars.length > 0) {
  throw new Error(`Missing required auth environment variables: ${missingAuthVars.join(', ')}`);
}

class AuthService {
  static async registerUser(userData) {
    const { email, password, name, phone } = userData;

    // Check if user already exists
    const existingUser = await User.findOne({
      where: { email },
    });

    if (existingUser) {
      throw new Error('User already exists with this email');
    }

    // Check phone number uniqueness if provided
    if (phone) {
      const existingPhone = await User.findOne({
        where: { phone },
      });

      if (existingPhone) {
        throw new Error('User already exists with this phone number');
      }
    }

    // Create new user
    const newUser = await User.create({
      email,
      password,
      name,
      phone,
      providerType: 'local',
    });

    // Return user without password
    return newUser.toSafeJSON();
  }

  static async loginUser(email, password) {
    // Find user by email
    const user = await User.findOne({
      where: { email, isActive: true },
    });

    if (!user) {
      throw new Error('Invalid email or password');
    }

    // Check if user has password (OAuth users might not)
    if (!user.password) {
      throw new Error('Please login using your OAuth provider');
    }

    // Verify password
    const isValidPassword = await user.validatePassword(password);
    if (!isValidPassword) {
      throw new Error('Invalid email or password');
    }

    // Generate tokens
    const payload = JWTUtil.createPayload(user);
    const tokens = JWTUtil.generateTokens(payload);

    return {
      user: user.toSafeJSON(),
      tokens,
    };
  }

  static async refreshToken(refreshToken) {
    try {
      const payload = JWTUtil.verifyRefreshToken(refreshToken);
      
      // Verify user still exists and is active
      const user = await User.findByPk(payload.id);
      if (!user || !user.isActive) {
        throw new Error('User not found or inactive');
      }

      // Generate new access token
      const newTokens = JWTUtil.refreshAccessToken(refreshToken);
      
      return {
        user: user.toSafeJSON(),
        tokens: newTokens,
      };
    } catch (error) {
      throw new Error('Invalid refresh token');
    }
  }

  static async createOAuthUser(profileData) {
    const { email, name, providerId, providerType, profileImage } = profileData;

    // Check if user already exists
    let user = await User.findOne({
      where: { email },
    });

    if (user) {
      // Update existing user with OAuth info
      await user.update({
        providerId,
        providerType,
        profileImage: profileImage || user.profileImage,
      });
    } else {
      // Create new OAuth user
      user = await User.create({
        email,
        name,
        providerId,
        providerType,
        profileImage,
        password: null, // OAuth users don't have passwords
      });
    }

    return user.toSafeJSON();
  }

  static async oauthLogin(profileData) {
    const user = await this.createOAuthUser(profileData);
    
    // Generate tokens
    const payload = JWTUtil.createPayload(user);
    const tokens = JWTUtil.generateTokens(payload);

    return {
      user,
      tokens,
    };
  }

  static async getUserById(userId) {
    const user = await User.findByPk(userId, {
      attributes: { exclude: ['password'] },
    });

    if (!user || !user.isActive) {
      throw new Error('User not found');
    }

    return user.toSafeJSON();
  }

  static async updateUserProfile(userId, updateData) {
    const user = await User.findByPk(userId);

    if (!user || !user.isActive) {
      throw new Error('User not found');
    }

    // Update allowed fields only
    const allowedFields = ['name', 'phone', 'profileImage', 'locationLat', 'locationLng'];
    const updateFields = {};

    allowedFields.forEach(field => {
      if (updateData[field] !== undefined) {
        updateFields[field] = updateData[field];
      }
    });

    await user.update(updateFields);
    
    return user.toSafeJSON();
  }

  static async deactivateUser(userId) {
    const user = await User.findByPk(userId);

    if (!user) {
      throw new Error('User not found');
    }

    await user.update({ isActive: false });
    
    return { message: 'User account deactivated successfully' };
  }
}

module.exports = AuthService;