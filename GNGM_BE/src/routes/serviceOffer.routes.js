const express = require('express');
const ServiceOfferController = require('../controllers/serviceOffer.controller');
const { authenticate, authRateLimit } = require('../middleware/auth.middleware');

const router = express.Router();

// All routes require authentication
router.use(authenticate);

// Service offer operations
router.post('/', authRateLimit, ServiceOfferController.createOffer);
router.get('/my', ServiceOfferController.getMyOffers);
router.get('/:id', ServiceOfferController.getOfferById);
router.put('/:id', authRateLimit, ServiceOfferController.updateOffer);
router.delete('/:id', authRateLimit, ServiceOfferController.cancelOffer);

// Request-specific offer operations
router.get('/request/:requestId', ServiceOfferController.getOffersForRequest);
router.post('/request/:requestId/:offerId/accept', authRateLimit, ServiceOfferController.acceptOffer);
router.post('/request/:requestId/:offerId/reject', authRateLimit, ServiceOfferController.rejectOffer);

module.exports = router;