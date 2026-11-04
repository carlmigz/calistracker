// Creates the tables from the Sequelize models.
// Pass --alter to update existing tables to match the models (keeps data), or --force to drop and recreate them.
const { sequelize } = require('../src/models');

(async () => {
  try {
    await sequelize.sync({
      alter: process.argv.includes('--alter'),
      force: process.argv.includes('--force'),
    });
    console.log('Tables synced.');
  } catch (e) {
    console.error('Migration failed:', e.message);
    process.exitCode = 1;
  } finally {
    await sequelize.close();
  }
})();
