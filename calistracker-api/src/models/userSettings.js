const { DataTypes } = require('sequelize');

// Whole number within a range, with a friendly message.
const wholeNumber = (min, max, msg) => ({
  isInt: { msg },
  min: { args: [min], msg },
  ...(max != null && { max: { args: [max], msg } }),
});

module.exports = (sequelize) => {
  const UserSettings = sequelize.define(
    'UserSettings',
    {
      userId: { type: DataTypes.BIGINT, primaryKey: true },
      themeMode: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: 'system',
        validate: {
          isIn: { args: [['system', 'light', 'dark']], msg: 'Please choose Light, Dark or System.' },
        },
      },
      weeklyGoal: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 3,
        validate: wholeNumber(1, 7, 'Your weekly goal must be between 1 and 7 days.'),
      },
      dailyGoal: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 3,
        validate: wholeNumber(1, null, 'Your daily goal must be at least 1 exercise.'),
      },
      avatarColorIndex: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
        validate: wholeNumber(0, null, 'Please choose a valid avatar color.'),
      },
      avatarAsset: { type: DataTypes.STRING, allowNull: false, defaultValue: '' },
      hapticsEnabled: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: true },
      soundEnabled: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: false },
      defaultRestSeconds: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 60,
        validate: wholeNumber(0, null, 'Rest time must be 0 seconds or more.'),
      },
      onboardingSeen: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: false },
    },
    { tableName: 'user_settings' },
  );

  /** Fields a client is allowed to change. */
  UserSettings.EDITABLE = [
    'themeMode',
    'weeklyGoal',
    'dailyGoal',
    'avatarColorIndex',
    'avatarAsset',
    'hapticsEnabled',
    'soundEnabled',
    'defaultRestSeconds',
    'onboardingSeen',
  ];

  UserSettings.prototype.toPublic = function toPublic() {
    return Object.fromEntries(UserSettings.EDITABLE.map((k) => [k, this[k]]));
  };

  return UserSettings;
};
