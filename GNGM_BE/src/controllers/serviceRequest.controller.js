const Joi = require('joi');
const ServiceRequestService = require('../services/serviceRequest.service');

// Validation schemas
const createRequestSchema = Joi.object({
  categoryType: Joi.string().valid('shopping', 'delivery', 'transport', 'companion').required(),
  title: Joi.string().min(5).max(100).required(),
  description: Joi.string().max(1000).optional(),
  pickupAddress: Joi.string().min(5).max(255).required(),
  pickupLat: Joi.number().min(-90).max(90).required(),
  pickupLng: Joi.number().min(-180).max(180).required(),
  deliveryAddress: Joi.string().min(5).max(255).optional(),
  deliveryLat: Joi.number().min(-90).max(90).optional(),
  deliveryLng: Joi.number().min(-180).max(180).optional(),
  feeAmount: Joi.number().integer().min(1000).max(1000000).required(),
  expiresAt: Joi.date().greater('now').optional()
});

const updateRequestSchema = Joi.object({
  title: Joi.string().min(5).max(100).optional(),
  description: Joi.string().max(1000).optional(),
  pickupAddress: Joi.string().min(5).max(255).optional(),
  deliveryAddress: Joi.string().min(5).max(255).optional(),
  feeAmount: Joi.number().integer().min(1000).max(1000000).optional(),
  expiresAt: Joi.date().greater('now').optional()
});

const getRequestsSchema = Joi.object({
  categoryType: Joi.string().valid('shopping', 'delivery', 'transport', 'companion').optional(),
  status: Joi.string().valid('pending', 'accepted', 'in_progress', 'completed', 'cancelled').optional(),
  lat: Joi.number().min(-90).max(90).optional(),
  lng: Joi.number().min(-180).max(180).optional(),
  radius: Joi.number().min(1).max(50).default(10).optional(),
  limit: Joi.number().integer().min(1).max(50).default(20).optional(),
  offset: Joi.number().integer().min(0).default(0).optional(),
  userId: Joi.string().uuid().optional()
});

const statusUpdateSchema = Joi.object({
  status: Joi.string().valid('cancelled', 'accepted', 'in_progress', 'completed').required()
});

class ServiceRequestController {
  static async createRequest(req, res, next) {
    try {
      const { error, value } = createRequestSchema.validate(req.body);
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const request = await ServiceRequestService.createServiceRequest(req.user.id, value);

      res.status(201).json({
        success: true,
        data: { request },
        message: 'Service request created successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  static async getRequests(req, res, next) {
    try {
      const { error, value } = getRequestsSchema.validate(req.query);
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const result = await ServiceRequestService.getServiceRequests(value);

      res.json({
        success: true,
        data: result,
        message: 'Service requests retrieved successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  static async getRequestById(req, res, next) {
    try {
      const { id } = req.params;

      const request = await ServiceRequestService.getServiceRequestById(id);

      res.json({
        success: true,
        data: { request },
        message: 'Service request retrieved successfully',
      });
    } catch (error) {
      if (error.message === 'Service request not found') {
        return res.status(404).json({
          success: false,
          error: error.message,
          code: 'REQUEST_NOT_FOUND',
        });
      }
      next(error);
    }
  }

  static async updateRequest(req, res, next) {
    try {
      const { id } = req.params;
      const { error, value } = updateRequestSchema.validate(req.body);
      
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const request = await ServiceRequestService.updateServiceRequest(id, req.user.id, value);

      res.json({
        success: true,
        data: { request },
        message: 'Service request updated successfully',
      });
    } catch (error) {
      if (error.message === 'Service request not found') {
        return res.status(404).json({
          success: false,
          error: error.message,
          code: 'REQUEST_NOT_FOUND',
        });
      }
      if (error.message === 'Not authorized to update this request' || 
          error.message === 'Cannot update request in current status') {
        return res.status(403).json({
          success: false,
          error: error.message,
          code: 'FORBIDDEN',
        });
      }
      next(error);
    }
  }

  static async deleteRequest(req, res, next) {
    try {
      const { id } = req.params;

      const result = await ServiceRequestService.deleteServiceRequest(id, req.user.id);

      res.json({
        success: true,
        data: null,
        message: result.message,
      });
    } catch (error) {
      if (error.message === 'Service request not found') {
        return res.status(404).json({
          success: false,
          error: error.message,
          code: 'REQUEST_NOT_FOUND',
        });
      }
      if (error.message === 'Not authorized to delete this request' || 
          error.message === 'Cannot delete request in current status') {
        return res.status(403).json({
          success: false,
          error: error.message,
          code: 'FORBIDDEN',
        });
      }
      next(error);
    }
  }

  static async updateStatus(req, res, next) {
    try {
      const { id } = req.params;
      const { error, value } = statusUpdateSchema.validate(req.body);
      
      if (error) {
        return res.status(400).json({
          success: false,
          error: error.details[0].message,
          code: 'VALIDATION_ERROR',
        });
      }

      const request = await ServiceRequestService.updateRequestStatus(id, value.status, req.user.id);

      res.json({
        success: true,
        data: { request },
        message: 'Service request status updated successfully',
      });
    } catch (error) {
      if (error.message === 'Service request not found') {
        return res.status(404).json({
          success: false,
          error: error.message,
          code: 'REQUEST_NOT_FOUND',
        });
      }
      if (error.message === 'Not authorized to update this request' || 
          error.message.includes('Cannot change status')) {
        return res.status(403).json({
          success: false,
          error: error.message,
          code: 'FORBIDDEN',
        });
      }
      next(error);
    }
  }

  static async getNearbyRequests(req, res, next) {
    try {
      const { lat, lng, radius = 10, limit = 20 } = req.query;

      if (!lat || !lng) {
        return res.status(400).json({
          success: false,
          error: 'Latitude and longitude are required',
          code: 'VALIDATION_ERROR',
        });
      }

      const requests = await ServiceRequestService.getNearbyRequests(
        parseFloat(lat), 
        parseFloat(lng), 
        parseFloat(radius), 
        parseInt(limit)
      );

      res.json({
        success: true,
        data: { requests },
        message: 'Nearby service requests retrieved successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  static async getMyRequests(req, res, next) {
    try {
      const { limit = 20, offset = 0 } = req.query;

      const result = await ServiceRequestService.getServiceRequests({
        userId: req.user.id,
        limit: parseInt(limit),
        offset: parseInt(offset)
      });

      res.json({
        success: true,
        data: result,
        message: 'My service requests retrieved successfully',
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = ServiceRequestController;