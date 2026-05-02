const Joi = require('joi');
const ServiceOfferService = require('../services/serviceOffer.service');

// Validation schemas
const createOfferSchema = Joi.object({
  requestId: Joi.string().uuid().required(),
  message: Joi.string().max(500).optional(),
  offeredFee: Joi.number().integer().min(1000).max(1000000).optional()
});

const updateOfferSchema = Joi.object({
  message: Joi.string().max(500).optional(),
  offeredFee: Joi.number().integer().min(1000).max(1000000).optional()
});

const getOffersSchema = Joi.object({
  status: Joi.string().valid('pending', 'accepted', 'rejected', 'cancelled').optional(),
  limit: Joi.number().integer().min(1).max(50).default(20).optional(),
  offset: Joi.number().integer().min(0).default(0).optional()
});

class ServiceOfferController {
  static async createOffer(req, res, next) {
    try {
      const { error, value } = createOfferSchema.validate(req.body);
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const offer = await ServiceOfferService.createServiceOffer(req.user.id, value);

      res.status(201).json({
        success: true,
        data: { offer },
        message: 'Service offer created successfully',
      });
    } catch (error) {
      if (error.message === 'Service request not found') {
        return res.status(404).json({
          success: false,
          error: error.message,
          code: 'REQUEST_NOT_FOUND',
        });
      }
      if (error.message === 'This request is no longer accepting offers' ||
          error.message === 'Cannot offer service to your own request' ||
          error.message === 'You have already offered to this request') {
        return res.status(400).json({
          success: false,
          error: error.message,
          code: 'BUSINESS_RULE_VIOLATION',
        });
      }
      next(error);
    }
  }

  static async getOfferById(req, res, next) {
    try {
      const { id } = req.params;

      const offer = await ServiceOfferService.getServiceOfferById(id);

      res.json({
        success: true,
        data: { offer },
        message: 'Service offer retrieved successfully',
      });
    } catch (error) {
      if (error.message === 'Service offer not found') {
        return res.status(404).json({
          success: false,
          error: error.message,
          code: 'OFFER_NOT_FOUND',
        });
      }
      next(error);
    }
  }

  static async getOffersForRequest(req, res, next) {
    try {
      const { requestId } = req.params;

      const offers = await ServiceOfferService.getOffersForRequest(requestId, req.user.id);

      res.json({
        success: true,
        data: { offers },
        message: 'Offers for request retrieved successfully',
      });
    } catch (error) {
      if (error.message === 'Service request not found') {
        return res.status(404).json({
          success: false,
          error: error.message,
          code: 'REQUEST_NOT_FOUND',
        });
      }
      if (error.message === 'Not authorized to view offers for this request') {
        return res.status(403).json({
          success: false,
          error: error.message,
          code: 'FORBIDDEN',
        });
      }
      next(error);
    }
  }

  static async getMyOffers(req, res, next) {
    try {
      const { error, value } = getOffersSchema.validate(req.query);
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const result = await ServiceOfferService.getUserOffers(req.user.id, value);

      res.json({
        success: true,
        data: result,
        message: 'My offers retrieved successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  static async acceptOffer(req, res, next) {
    try {
      const { requestId, offerId } = req.params;

      const offer = await ServiceOfferService.acceptOffer(requestId, offerId, req.user.id);

      res.json({
        success: true,
        data: { offer },
        message: 'Offer accepted successfully',
      });
    } catch (error) {
      if (error.message === 'Not authorized to accept offers for this request' ||
          error.message === 'This request is no longer accepting offers' ||
          error.message === 'Offer not found or no longer available') {
        return res.status(400).json({
          success: false,
          error: error.message,
          code: 'BUSINESS_RULE_VIOLATION',
        });
      }
      next(error);
    }
  }

  static async rejectOffer(req, res, next) {
    try {
      const { requestId, offerId } = req.params;

      const offer = await ServiceOfferService.rejectOffer(requestId, offerId, req.user.id);

      res.json({
        success: true,
        data: { offer },
        message: 'Offer rejected successfully',
      });
    } catch (error) {
      if (error.message === 'Not authorized to reject offers for this request' ||
          error.message === 'Offer not found or no longer available') {
        return res.status(400).json({
          success: false,
          error: error.message,
          code: 'BUSINESS_RULE_VIOLATION',
        });
      }
      next(error);
    }
  }

  static async updateOffer(req, res, next) {
    try {
      const { id } = req.params;
      const { error, value } = updateOfferSchema.validate(req.body);
      
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const offer = await ServiceOfferService.updateOffer(id, req.user.id, value);

      res.json({
        success: true,
        data: { offer },
        message: 'Offer updated successfully',
      });
    } catch (error) {
      if (error.message === 'Not authorized to update this offer' ||
          error.message === 'Cannot update offer in current status') {
        return res.status(400).json({
          success: false,
          error: error.message,
          code: 'BUSINESS_RULE_VIOLATION',
        });
      }
      next(error);
    }
  }

  static async cancelOffer(req, res, next) {
    try {
      const { id } = req.params;

      const offer = await ServiceOfferService.cancelOffer(id, req.user.id);

      res.json({
        success: true,
        data: { offer },
        message: 'Offer cancelled successfully',
      });
    } catch (error) {
      if (error.message === 'Not authorized to cancel this offer' ||
          error.message === 'Cannot cancel offer in current status') {
        return res.status(400).json({
          success: false,
          error: error.message,
          code: 'BUSINESS_RULE_VIOLATION',
        });
      }
      next(error);
    }
  }
}

module.exports = ServiceOfferController;