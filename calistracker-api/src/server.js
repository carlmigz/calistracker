const app = require('./app');
const config = require('./config');
const { sequelize } = require('./models');
const logger = require('./utils/logger');

process.on('unhandledRejection', (reason) => logger.error(`Unhandled rejection: ${reason?.stack || reason}`));
process.on('uncaughtException', (err) => {
  logger.error(`Uncaught exception: ${err.stack || err}`);
  process.exit(1);
});

app.listen(config.port, async () => {
  logger.info(`CalisTracker API listening on http://localhost:${config.port}`);
  try {
    await sequelize.authenticate();
    logger.info('Database connected.');
  } catch (e) {
    logger.warn(
      `Database not reachable (${e.message}). Check the DB_* values in .env, then run "npm run db:setup".`,
    );
  }
});
