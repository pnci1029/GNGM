const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const ServiceOffer = sequelize.define('ServiceOffer', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    requestId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'service_requests',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    providerId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    message: {
      type: DataTypes.TEXT,
      allowNull: true,
      comment: '제공자가 남긴 메시지',
    },
    offeredFee: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: '제안하는 수수료 (원래 요청과 다른 금액 제안 시)',
    },
    status: {
      type: DataTypes.ENUM('pending', 'accepted', 'rejected', 'cancelled'),
      allowNull: false,
      defaultValue: 'pending',
    },
    acceptedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      comment: '제공자가 선택된 시각',
    },
    rejectedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      comment: '거절된 시각',
    },
  }, {
    tableName: 'service_offers',
    timestamps: true,
    paranoid: false,
    indexes: [
      {
        fields: ['requestId'],
        name: 'service_offers_request_id'
      },
      {
        fields: ['providerId'],
        name: 'service_offers_provider_id'
      },
      {
        fields: ['status'],
        name: 'service_offers_status'
      },
      {
        unique: true,
        fields: ['requestId', 'providerId'],
        name: 'unique_offer_per_request_provider'
      }
    ],
  });

  ServiceOffer.associate = (models) => {
    // ServiceOffer belongs to ServiceRequest
    ServiceOffer.belongsTo(models.ServiceRequest, {
      foreignKey: 'requestId',
      as: 'serviceRequest'
    });

    // ServiceOffer belongs to User (provider)
    ServiceOffer.belongsTo(models.User, {
      foreignKey: 'providerId',
      as: 'provider'
    });
  };

  // Instance methods
  ServiceOffer.prototype.toSafeJSON = function() {
    const offer = this.toJSON();
    return {
      id: offer.id,
      requestId: offer.requestId,
      providerId: offer.providerId,
      message: offer.message,
      offeredFee: offer.offeredFee,
      status: offer.status,
      acceptedAt: offer.acceptedAt,
      rejectedAt: offer.rejectedAt,
      createdAt: offer.createdAt,
      updatedAt: offer.updatedAt,
      // Include associated data if loaded
      ...(offer.provider && { provider: offer.provider }),
      ...(offer.serviceRequest && { serviceRequest: offer.serviceRequest })
    };
  };

  return ServiceOffer;
};