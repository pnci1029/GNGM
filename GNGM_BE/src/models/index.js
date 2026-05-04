const { sequelize } = require('../config/database');

// Import models
const UserModel = require('./user.model');
const ServiceRequestModel = require('./serviceRequest.model');
const ServiceOfferModel = require('./serviceOffer.model');
const ChatRoomModel = require('./chatRoom.model');
const ChatMessageModel = require('./chatMessage.model');

// Initialize models
const User = UserModel(sequelize);
const ServiceRequest = ServiceRequestModel(sequelize);
const ServiceOffer = ServiceOfferModel(sequelize);
const ChatRoom = ChatRoomModel(sequelize);
const ChatMessage = ChatMessageModel(sequelize);

// Define associations
User.hasMany(ServiceRequest, {
  foreignKey: 'userId',
  as: 'serviceRequests',
});

ServiceRequest.belongsTo(User, {
  foreignKey: 'userId',
  as: 'user',
});

// ServiceOffer associations
User.hasMany(ServiceOffer, {
  foreignKey: 'providerId',
  as: 'serviceOffers',
});

ServiceOffer.belongsTo(User, {
  foreignKey: 'providerId',
  as: 'provider',
});

ServiceRequest.hasMany(ServiceOffer, {
  foreignKey: 'requestId',
  as: 'serviceOffers',
});

ServiceOffer.belongsTo(ServiceRequest, {
  foreignKey: 'requestId',
  as: 'serviceRequest',
});

// Chat associations
ChatRoom.associate({ User, ServiceRequest, ServiceOffer, ChatMessage });
ChatMessage.associate({ User, ChatRoom });

// Additional associations for chat
ServiceRequest.hasMany(ChatRoom, {
  foreignKey: 'requestId',
  as: 'chatRooms',
});

ServiceOffer.hasMany(ChatRoom, {
  foreignKey: 'offerId',
  as: 'chatRooms',
});

// Export models and sequelize instance
const models = {
  User,
  ServiceRequest,
  ServiceOffer,
  ChatRoom,
  ChatMessage,
  sequelize,
};

module.exports = models;