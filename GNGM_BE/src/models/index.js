const { sequelize } = require('../config/database');

// Import models
const UserModel = require('./user.model');
const ServiceRequestModel = require('./serviceRequest.model');

// Initialize models
const User = UserModel(sequelize);
const ServiceRequest = ServiceRequestModel(sequelize);

// Define associations
User.hasMany(ServiceRequest, {
  foreignKey: 'userId',
  as: 'serviceRequests',
});

ServiceRequest.belongsTo(User, {
  foreignKey: 'userId',
  as: 'user',
});

// Export models and sequelize instance
const models = {
  User,
  ServiceRequest,
  sequelize,
};

module.exports = models;