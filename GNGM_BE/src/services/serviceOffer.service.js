const { ServiceOffer, ServiceRequest, User, sequelize } = require('../models');
const { Op } = require('sequelize');
require('dotenv').config();

class ServiceOfferService {
  static async createServiceOffer(providerId, offerData) {
    const { requestId, message, offeredFee } = offerData;

    // 요청이 존재하고 pending 상태인지 확인
    const request = await ServiceRequest.findByPk(requestId);
    if (!request) {
      throw new Error('Service request not found');
    }

    if (request.status !== 'pending') {
      throw new Error('This request is no longer accepting offers');
    }

    // 본인의 요청에는 지원할 수 없음
    if (request.userId === providerId) {
      throw new Error('Cannot offer service to your own request');
    }

    // 이미 지원했는지 확인
    const existingOffer = await ServiceOffer.findOne({
      where: { requestId, providerId }
    });

    if (existingOffer) {
      throw new Error('You have already offered to this request');
    }

    // 새 지원 생성
    const offer = await ServiceOffer.create({
      requestId,
      providerId,
      message,
      offeredFee: offeredFee || request.feeAmount,
      status: 'pending'
    });

    return await this.getServiceOfferById(offer.id);
  }

  static async getServiceOfferById(offerId) {
    const offer = await ServiceOffer.findByPk(offerId, {
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'name', 'profileImage', 'ratingAvg', 'trustScore']
        },
        {
          model: ServiceRequest,
          as: 'serviceRequest',
          attributes: ['id', 'title', 'categoryType', 'status', 'feeAmount']
        }
      ]
    });

    if (!offer) {
      throw new Error('Service offer not found');
    }

    return offer;
  }

  static async getOffersForRequest(requestId, requesterId) {
    // 요청자만 지원 목록을 볼 수 있음
    const request = await ServiceRequest.findByPk(requestId);
    if (!request) {
      throw new Error('Service request not found');
    }

    if (request.userId !== requesterId) {
      throw new Error('Not authorized to view offers for this request');
    }

    const offers = await ServiceOffer.findAll({
      where: { requestId },
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'name', 'profileImage', 'ratingAvg', 'trustScore']
        }
      ],
      order: [['createdAt', 'ASC']]
    });

    return offers;
  }

  static async getUserOffers(userId, filters = {}) {
    const { status, limit = 20, offset = 0 } = filters;

    const whereClause = { providerId: userId };

    if (status) {
      whereClause.status = status;
    }

    const { rows: offers, count } = await ServiceOffer.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: ServiceRequest,
          as: 'serviceRequest',
          attributes: ['id', 'title', 'categoryType', 'status', 'feeAmount', 'pickupAddress'],
          include: [
            {
              model: User,
              as: 'user',
              attributes: ['id', 'name', 'profileImage', 'ratingAvg']
            }
          ]
        }
      ],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset)
    });

    return {
      offers,
      total: count,
      hasMore: offset + limit < count
    };
  }

  static async acceptOffer(requestId, offerId, requesterId) {
    const transaction = await sequelize.transaction();

    try {
      // 요청 확인
      const request = await ServiceRequest.findByPk(requestId, { transaction });
      if (!request || request.userId !== requesterId) {
        throw new Error('Not authorized to accept offers for this request');
      }

      if (request.status !== 'pending') {
        throw new Error('This request is no longer accepting offers');
      }

      // 지원 확인
      const offer = await ServiceOffer.findOne({
        where: { id: offerId, requestId },
        transaction
      });

      if (!offer || offer.status !== 'pending') {
        throw new Error('Offer not found or no longer available');
      }

      // 선택된 지원을 accepted로 변경
      await offer.update({
        status: 'accepted',
        acceptedAt: new Date()
      }, { transaction });

      // 요청 상태를 accepted로 변경
      await request.update({
        status: 'accepted'
      }, { transaction });

      // 다른 지원들을 모두 rejected로 변경
      await ServiceOffer.update({
        status: 'rejected',
        rejectedAt: new Date()
      }, {
        where: {
          requestId,
          id: { [Op.ne]: offerId }
        },
        transaction
      });

      await transaction.commit();

      return await this.getServiceOfferById(offerId);
    } catch (error) {
      await transaction.rollback();
      throw error;
    }
  }

  static async rejectOffer(requestId, offerId, requesterId) {
    // 요청 확인
    const request = await ServiceRequest.findByPk(requestId);
    if (!request || request.userId !== requesterId) {
      throw new Error('Not authorized to reject offers for this request');
    }

    // 지원 확인
    const offer = await ServiceOffer.findOne({
      where: { id: offerId, requestId }
    });

    if (!offer || offer.status !== 'pending') {
      throw new Error('Offer not found or no longer available');
    }

    // 지원을 rejected로 변경
    await offer.update({
      status: 'rejected',
      rejectedAt: new Date()
    });

    return await this.getServiceOfferById(offerId);
  }

  static async cancelOffer(offerId, providerId) {
    // 지원 확인
    const offer = await ServiceOffer.findByPk(offerId);
    if (!offer || offer.providerId !== providerId) {
      throw new Error('Not authorized to cancel this offer');
    }

    if (offer.status !== 'pending') {
      throw new Error('Cannot cancel offer in current status');
    }

    // 지원을 cancelled로 변경
    await offer.update({
      status: 'cancelled'
    });

    return await this.getServiceOfferById(offerId);
  }

  static async updateOffer(offerId, providerId, updateData) {
    // 지원 확인
    const offer = await ServiceOffer.findByPk(offerId);
    if (!offer || offer.providerId !== providerId) {
      throw new Error('Not authorized to update this offer');
    }

    if (offer.status !== 'pending') {
      throw new Error('Cannot update offer in current status');
    }

    const allowedFields = ['message', 'offeredFee'];
    const updateFields = {};

    allowedFields.forEach(field => {
      if (updateData[field] !== undefined) {
        updateFields[field] = updateData[field];
      }
    });

    await offer.update(updateFields);

    return await this.getServiceOfferById(offerId);
  }
}

module.exports = ServiceOfferService;