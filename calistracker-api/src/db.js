const { Sequelize } = require('sequelize');
const config = require('./config');

const options = {
  dialect: 'postgres',
  logging: config.databaseLogging ? console.log : false,
  dialectOptions: config.databaseSsl ? { ssl: { require: true, rejectUnauthorized: false } } : {},
  define: { underscored: true, timestamps: false },
};

const sequelize = config.databaseUrl
  ? new Sequelize(config.databaseUrl, options)
  : new Sequelize(config.db.name, config.db.user, config.db.password, {
      ...options,
      host: config.db.host,
      port: config.db.port,
    });

module.exports = sequelize;
