const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const ChatRoom = sequelize.define('ChatRoom', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
      allowNull: false,
    },
    requestId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'service_requests',
        key: 'id',
      },
      onDelete: 'CASCADE',
    },
    offerId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'service_offers',
        key: 'id',
      },
      onDelete: 'CASCADE',
    },
    requesterId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id',
      },
      onDelete: 'CASCADE',
    },
    providerId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id',
      },
      onDelete: 'CASCADE',
    },
    status: {
      type: DataTypes.ENUM('active', 'closed'),
      defaultValue: 'active',
      allowNull: false,
    },
    lastMessageAt: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
    updatedAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
  }, {
    tableName: 'chat_rooms',
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ['requestId', 'offerId'],
        name: 'unique_request_offer',
      },
      {
        fields: ['requesterId'],
      },
      {
        fields: ['providerId'],
      },
      {
        fields: ['status'],
      },
    ],
  });

  ChatRoom.associate = (models) => {
    ChatRoom.belongsTo(models.ServiceRequest, {
      foreignKey: 'requestId',
      as: 'request',
    });
    ChatRoom.belongsTo(models.ServiceOffer, {
      foreignKey: 'offerId',
      as: 'offer',
    });
    ChatRoom.belongsTo(models.User, {
      foreignKey: 'requesterId',
      as: 'requester',
    });
    ChatRoom.belongsTo(models.User, {
      foreignKey: 'providerId',
      as: 'provider',
    });
    ChatRoom.hasMany(models.ChatMessage, {
      foreignKey: 'chatRoomId',
      as: 'messages',
    });
  };

  return ChatRoom;
};