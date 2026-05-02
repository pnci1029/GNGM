const jwt = require('jsonwebtoken');
require('dotenv').config();

// Validate required JWT environment variables
const requiredJwtVars = ['JWT_SECRET', 'JWT_REFRESH_SECRET', 'JWT_EXPIRES_IN', 'JWT_REFRESH_EXPIRES_IN'];
const missingJwtVars = requiredJwtVars.filter(varName => !process.env[varName]);

if (missingJwtVars.length > 0) {
  throw new Error(`Missing required JWT environment variables: ${missingJwtVars.join(', ')}`);
}

class JWTUtil {
  static generateTokens(payload) {
    const accessToken = jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    const refreshToken = jwt.sign(
      payload,
      process.env.JWT_REFRESH_SECRET,
      { expiresIn: process.env.JWT_REFRESH_EXPIRES_IN }
    );

    return { accessToken, refreshToken };
  }

  static verifyAccessToken(token) {
    try {
      return jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
      throw new Error('Invalid access token');
    }
  }

  static verifyRefreshToken(token) {
    try {
      return jwt.verify(token, process.env.JWT_REFRESH_SECRET);
    } catch (error) {
      throw new Error('Invalid refresh token');
    }
  }

  static extractTokenFromHeader(authHeader) {
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new Error('Invalid authorization header');
    }
    return authHeader.substring(7);
  }

  static createPayload(user) {
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      providerType: user.providerType,
      iat: Math.floor(Date.now() / 1000),
    };
  }

  static refreshAccessToken(refreshToken) {
    try {
      const payload = this.verifyRefreshToken(refreshToken);
      
      // Create new payload (remove old timestamps)
      const newPayload = {
        id: payload.id,
        email: payload.email,
        name: payload.name,
        providerType: payload.providerType,
      };

      const newAccessToken = jwt.sign(
        newPayload,
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );

      return { accessToken: newAccessToken };
    } catch (error) {
      throw new Error('Failed to refresh token');
    }
  }
}

module.exports = JWTUtil;