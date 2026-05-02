const express = require('express');
const AuthController = require('../controllers/auth.controller');
const { 
  authenticate, 
  authRateLimit, 
  loginRateLimit 
} = require('../middleware/auth.middleware');

const router = express.Router();

// Public routes with rate limiting
router.post('/register', authRateLimit, AuthController.register);
router.post('/login', loginRateLimit, AuthController.login);
router.post('/refresh', authRateLimit, AuthController.refreshToken);

// Protected routes
router.get('/profile', authenticate, AuthController.getProfile);
router.put('/profile', authenticate, AuthController.updateProfile);
router.delete('/account', authenticate, AuthController.deleteAccount);
router.post('/logout', authenticate, AuthController.logout);

module.exports = router;