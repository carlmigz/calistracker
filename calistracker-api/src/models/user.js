const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const User = sequelize.define(
    'User',
    {
      id: { type: DataTypes.BIGINT, primaryKey: true, autoIncrement: true },
      email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        set(value) {
          this.setDataValue('email', String(value ?? '').trim().toLowerCase());
        },
        validate: { isEmail: { msg: 'Please enter a valid email address.' } },
      },
      username: {
        type: DataTypes.STRING(30),
        allowNull: true,
        unique: true,
        set(value) {
          const v = String(value ?? '').trim().toLowerCase();
          this.setDataValue('username', v || null);
        },
        validate: {
          is: {
            args: /^[a-z0-9_]{3,30}$/,
            msg: 'Username must be 3 to 30 characters, using only letters, numbers or underscores.',
          },
        },
      },
      passwordHash: { type: DataTypes.STRING, allowNull: false },
      displayName: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: 'Athlete',
        validate: { notEmpty: { msg: 'Please enter your name.' } },
      },
      createdAt: { type: DataTypes.DATE, allowNull: false, defaultValue: DataTypes.NOW },
    },
    { tableName: 'users' },
  );

  User.prototype.toPublic = function toPublic() {
    return {
      id: this.id,
      email: this.email,
      username: this.username,
      displayName: this.displayName,
    };
  };

  return User;
};
