const sequelize = require('../db');

const User = require('./user')(sequelize);
const UserSettings = require('./userSettings')(sequelize);
const Program = require('./program')(sequelize);
const Exercise = require('./exercise')(sequelize);
const Completion = require('./completion')(sequelize);

User.hasOne(UserSettings, { foreignKey: 'userId', as: 'settings', onDelete: 'CASCADE' });
UserSettings.belongsTo(User, { foreignKey: 'userId' });

User.hasMany(Completion, { foreignKey: 'userId', onDelete: 'CASCADE' });
Completion.belongsTo(User, { foreignKey: 'userId' });

Program.hasMany(Exercise, { foreignKey: 'programId', as: 'exercises', onDelete: 'CASCADE' });
Exercise.belongsTo(Program, { foreignKey: 'programId' });

Exercise.hasMany(Completion, { foreignKey: 'exerciseId', onDelete: 'CASCADE' });
Completion.belongsTo(Exercise, { foreignKey: 'exerciseId' });

module.exports = { sequelize, User, UserSettings, Program, Exercise, Completion };
