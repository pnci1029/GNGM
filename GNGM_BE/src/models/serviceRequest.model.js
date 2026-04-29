const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  const ServiceRequest = sequelize.define(
    'ServiceRequest',
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      userId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: 'user_id',
        references: {
          model: 'users',
          key: 'id',
        },
      },
      categoryType: {
        type: DataTypes.ENUM('shopping', 'delivery', 'transport', 'companion'),
        allowNull: false,
        field: 'category_type',
      },
      title: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
          len: [5, 100],
        },
      },
      description: {
        type: DataTypes.TEXT,
        allowNull: true,
        validate: {
          len: [0, 1000],
        },
      },
      pickupAddress: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'pickup_address',
      },
      pickupLat: {
        type: DataTypes.DECIMAL(10, 8),
        allowNull: false,
        field: 'pickup_lat',
      },
      pickupLng: {
        type: DataTypes.DECIMAL(11, 8),
        allowNull: false,
        field: 'pickup_lng',
      },
      deliveryAddress: {
        type: DataTypes.STRING,
        allowNull: true,
        field: 'delivery_address',
      },
      deliveryLat: {
        type: DataTypes.DECIMAL(10, 8),
        allowNull: true,
        field: 'delivery_lat',
      },
      deliveryLng: {
        type: DataTypes.DECIMAL(11, 8),
        allowNull: true,
        field: 'delivery_lng',
      },
      feeAmount: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: 'fee_amount',
        validate: {
          min: 1000, // 최소 1,000원
          max: 100000, // 최대 100,000원
        },
      },
      status: {
        type: DataTypes.ENUM(
          'pending',
          'accepted',
          'in_progress',
          'completed',
          'cancelled',
        ),
        allowNull: false,
        defaultValue: 'pending',
      },
      expiresAt: {
        type: DataTypes.DATE,
        allowNull: false,
        field: 'expires_at',
        validate: {
          isAfter: new Date().toISOString(),
        },
      },
      completedAt: {
        type: DataTypes.DATE,
        allowNull: true,
        field: 'completed_at',
      },
    },
    {
      tableName: 'service_requests',
      timestamps: true,
      underscored: true,
      indexes: [
        {
          fields: ['user_id'],
        },
        {
          fields: ['category_type'],
        },
        {
          fields: ['status'],
        },
        {
          fields: ['pickup_lat', 'pickup_lng'],
          name: 'pickup_location_idx',
        },
      ],
    },
  );

  return ServiceRequest;
};