const Joi = require('joi');
const AuthService = require('../services/auth.service');

// Validation schemas
const registerSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(8).required(),
  name: Joi.string().min(2).max(50).required(),
  phone: Joi.string().pattern(/^010-\d{4}-\d{4}$/).optional(),
});

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

const refreshSchema = Joi.object({
  refreshToken: Joi.string().required(),
});

const updateProfileSchema = Joi.object({
  name: Joi.string().min(2).max(50).optional(),
  phone: Joi.string().pattern(/^010-\d{4}-\d{4}$/).optional(),
  profileImage: Joi.string().uri().optional(),
  locationLat: Joi.number().min(-90).max(90).optional(),
  locationLng: Joi.number().min(-180).max(180).optional(),
});

class AuthController {
  static async register(req, res, next) {
    try {
      const { error, value } = registerSchema.validate(req.body);
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const user = await AuthService.registerUser(value);

      res.status(201).json({
        success: true,
        data: { user },
        message: 'User registered successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  static async login(req, res, next) {
    try {
      const { error, value } = loginSchema.validate(req.body);
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const result = await AuthService.loginUser(value.email, value.password);

      res.json({
        success: true,
        data: result,
        message: 'Login successful',
      });
    } catch (error) {
      if (error.message === 'Invalid email or password') {
        return res.status(401).json({
          success: false,
          error: error.message,
          code: 'INVALID_CREDENTIALS',
        });
      }
      next(error);
    }
  }

  static async refreshToken(req, res, next) {
    try {
      const { error, value } = refreshSchema.validate(req.body);
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const result = await AuthService.refreshToken(value.refreshToken);

      res.json({
        success: true,
        data: result,
        message: 'Token refreshed successfully',
      });
    } catch (error) {
      return res.status(401).json({
        success: false,
        error: error.message,
        code: 'INVALID_REFRESH_TOKEN',
      });
    }
  }

  static async getProfile(req, res, next) {
    try {
      const user = await AuthService.getUserById(req.user.id);

      res.json({
        success: true,
        data: { user },
        message: 'Profile retrieved successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  static async updateProfile(req, res, next) {
    try {
      const { error, value } = updateProfileSchema.validate(req.body);
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const user = await AuthService.updateUserProfile(req.user.id, value);

      res.json({
        success: true,
        data: { user },
        message: 'Profile updated successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  static async deleteAccount(req, res, next) {
    try {
      await AuthService.deactivateUser(req.user.id);

      res.json({
        success: true,
        data: null,
        message: 'Account deactivated successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  static async logout(req, res) {
    // In a stateless JWT system, logout is handled client-side
    // But we can implement token blacklisting here if needed
    res.json({
      success: true,
      data: null,
      message: 'Logout successful',
    });
  }
}

module.exports = AuthController;