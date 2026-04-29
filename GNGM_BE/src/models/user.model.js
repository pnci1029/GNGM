const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');

module.exports = sequelize => {
  const User = sequelize.define(
    'User',
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
          isEmail: true,
        },
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
          len: [2, 50],
        },
      },
      phone: {
        type: DataTypes.STRING,
        allowNull: true,
        unique: true,
        validate: {
          is: /^010-\d{4}-\d{4}$/,
        },
      },
      profileImage: {
        type: DataTypes.STRING,
        allowNull: true,
        field: 'profile_image',
      },
      providerType: {
        type: DataTypes.ENUM('local', 'kakao', 'google'),
        allowNull: false,
        defaultValue: 'local',
        field: 'provider_type',
      },
      providerId: {
        type: DataTypes.STRING,
        allowNull: true,
        field: 'provider_id',
      },
      password: {
        type: DataTypes.STRING,
        allowNull: true, // OAuth users may not have password
      },
      ratingAvg: {
        type: DataTypes.DECIMAL(2, 1),
        allowNull: true,
        defaultValue: null,
        field: 'rating_avg',
        validate: {
          min: 0,
          max: 5,
        },
      },
      trustScore: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
        field: 'trust_score',
        validate: {
          min: 0,
          max: 1000,
        },
      },
      locationLat: {
        type: DataTypes.DECIMAL(10, 8),
        allowNull: true,
        field: 'location_lat',
      },
      locationLng: {
        type: DataTypes.DECIMAL(11, 8),
        allowNull: true,
        field: 'location_lng',
      },
      isActive: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
        field: 'is_active',
      },
    },
    {
      tableName: 'users',
      timestamps: true,
      paranoid: true, // soft delete
      underscored: true,
      hooks: {
        beforeCreate: async user => {
          if (user.password) {
            user.password = await bcrypt.hash(user.password, 12);
          }
        },
        beforeUpdate: async user => {
          if (user.changed('password') && user.password) {
            user.password = await bcrypt.hash(user.password, 12);
          }
        },
      },
    },
  );

  // Instance methods
  User.prototype.validatePassword = async function (password) {
    if (!this.password) return false;
    return bcrypt.compare(password, this.password);
  };

  User.prototype.toSafeJSON = function () {
    const values = { ...this.get() };
    delete values.password;
    return values;
  };

  return User;
};