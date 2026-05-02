const { sequelize } = require('../config/database');

// Import models
const UserModel = require('./user.model');
const ServiceRequestModel = require('./serviceRequest.model');
const ServiceOfferModel = require('./serviceOffer.model');

// Initialize models
const User = UserModel(sequelize);
const ServiceRequest = ServiceRequestModel(sequelize);
const ServiceOffer = ServiceOfferModel(sequelize);

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

// Export models and sequelize instance
const models = {
  User,
  ServiceRequest,
  ServiceOffer,
  sequelize,
};

module.exports = models;