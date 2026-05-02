const { ServiceRequest, User, sequelize } = require('../models');
const { Op } = require('sequelize');
require('dotenv').config();

class ServiceRequestService {
  static async createServiceRequest(userId, requestData) {
    const {
      categoryType,
      title,
      description,
      pickupAddress,
      pickupLat,
      pickupLng,
      deliveryAddress,
      deliveryLat,
      deliveryLng,
      feeAmount,
      expiresAt
    } = requestData;

    const serviceRequest = await ServiceRequest.create({
      userId,
      categoryType,
      title,
      description,
      pickupAddress,
      pickupLat,
      pickupLng,
      deliveryAddress,
      deliveryLat,
      deliveryLng,
      feeAmount,
      expiresAt: expiresAt || new Date(Date.now() + 24 * 60 * 60 * 1000), // 24시간 후
      status: 'pending'
    });

    return await this.getServiceRequestById(serviceRequest.id);
  }

  static async getServiceRequests(filters = {}) {
    const {
      categoryType,
      status,
      lat,
      lng,
      radius = 10, // km
      limit = 20,
      offset = 0,
      userId
    } = filters;

    const whereClause = {
      expiresAt: {
        [Op.gt]: new Date() // 만료되지 않은 요청만
      }
    };

    if (categoryType) {
      whereClause.categoryType = categoryType;
    }

    if (status) {
      whereClause.status = status;
    }

    if (userId) {
      whereClause.userId = userId;
    }

    // 위치 기반 필터링 (반경 내 요청)
    if (lat && lng && radius) {
      whereClause[Op.and] = [
        sequelize.literal(`
          6371 * acos(cos(radians(${lat})) 
          * cos(radians(pickup_lat)) 
          * cos(radians(pickup_lng) - radians(${lng})) 
          + sin(radians(${lat})) 
          * sin(radians(pickup_lat))) <= ${radius}
        `)
      ];
    }

    const { rows: requests, count } = await ServiceRequest.findAndCountAll({
      where: whereClause,
      include: [{
        model: User,
        as: 'user',
        attributes: ['id', 'name', 'profileImage', 'ratingAvg', 'trustScore']
      }],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset)
    });

    return {
      requests,
      total: count,
      hasMore: offset + limit < count
    };
  }

  static async getServiceRequestById(requestId) {
    const request = await ServiceRequest.findByPk(requestId, {
      include: [{
        model: User,
        as: 'user',
        attributes: ['id', 'name', 'profileImage', 'ratingAvg', 'trustScore']
      }]
    });

    if (!request) {
      throw new Error('Service request not found');
    }

    return request;
  }

  static async updateServiceRequest(requestId, userId, updateData) {
    const request = await ServiceRequest.findByPk(requestId);

    if (!request) {
      throw new Error('Service request not found');
    }

    // 요청자만 수정 가능
    if (request.userId !== userId) {
      throw new Error('Not authorized to update this request');
    }

    // pending 상태일 때만 수정 가능
    if (request.status !== 'pending') {
      throw new Error('Cannot update request in current status');
    }

    const allowedFields = [
      'title', 'description', 'pickupAddress', 'deliveryAddress',
      'feeAmount', 'expiresAt'
    ];

    const updateFields = {};
    allowedFields.forEach(field => {
      if (updateData[field] !== undefined) {
        updateFields[field] = updateData[field];
      }
    });

    await request.update(updateFields);
    
    return await this.getServiceRequestById(requestId);
  }

  static async deleteServiceRequest(requestId, userId) {
    const request = await ServiceRequest.findByPk(requestId);

    if (!request) {
      throw new Error('Service request not found');
    }

    // 요청자만 삭제 가능
    if (request.userId !== userId) {
      throw new Error('Not authorized to delete this request');
    }

    // pending 상태일 때만 삭제 가능
    if (request.status !== 'pending') {
      throw new Error('Cannot delete request in current status');
    }

    await request.destroy();
    
    return { message: 'Service request deleted successfully' };
  }

  static async updateRequestStatus(requestId, newStatus, userId) {
    const request = await ServiceRequest.findByPk(requestId);

    if (!request) {
      throw new Error('Service request not found');
    }

    // 요청자만 상태 변경 가능
    if (request.userId !== userId) {
      throw new Error('Not authorized to update this request');
    }

    const validStatusTransitions = {
      'pending': ['cancelled'],
      'accepted': ['in_progress', 'cancelled'],
      'in_progress': ['completed', 'cancelled'],
      'completed': [],
      'cancelled': []
    };

    const allowedStatuses = validStatusTransitions[request.status];
    
    if (!allowedStatuses.includes(newStatus)) {
      throw new Error(`Cannot change status from ${request.status} to ${newStatus}`);
    }

    await request.update({ 
      status: newStatus,
      completedAt: newStatus === 'completed' ? new Date() : null
    });

    return await this.getServiceRequestById(requestId);
  }

  static async getNearbyRequests(userLat, userLng, radius = 10, limit = 20) {
    const requests = await ServiceRequest.findAll({
      where: {
        status: 'pending',
        expiresAt: {
          [Op.gt]: new Date()
        },
        [Op.and]: [
          sequelize.literal(`
            6371 * acos(cos(radians(${userLat})) 
            * cos(radians(pickup_lat)) 
            * cos(radians(pickup_lng) - radians(${userLng})) 
            + sin(radians(${userLat})) 
            * sin(radians(pickup_lat))) <= ${radius}
          `)
        ]
      },
      include: [{
        model: User,
        as: 'user',
        attributes: ['id', 'name', 'profileImage', 'ratingAvg', 'trustScore']
      }],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit)
    });

    return requests;
  }
}

module.exports = ServiceRequestService;