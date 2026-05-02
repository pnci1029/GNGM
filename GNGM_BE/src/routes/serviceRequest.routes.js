const express = require('express');
const ServiceRequestController = require('../controllers/serviceRequest.controller');
const { authenticate, authRateLimit } = require('../middleware/auth.middleware');

const router = express.Router();

// Public routes (require authentication)
router.use(authenticate);

// Service request CRUD operations
router.post('/', authRateLimit, ServiceRequestController.createRequest);
router.get('/', ServiceRequestController.getRequests);
router.get('/nearby', ServiceRequestController.getNearbyRequests);
router.get('/my', ServiceRequestController.getMyRequests);
router.get('/:id', ServiceRequestController.getRequestById);
router.put('/:id', authRateLimit, ServiceRequestController.updateRequest);
router.delete('/:id', authRateLimit, ServiceRequestController.deleteRequest);

// Status management
router.patch('/:id/status', authRateLimit, ServiceRequestController.updateStatus);

module.exports = router;