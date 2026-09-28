require('dotenv').config();

const { config } = require('./src/config');
const { initializeDatabase } = require('./src/db');
const logger = require('./src/services/logger');

initializeDatabase().then(() => {
  require('./src/db/seed').seedDatabase();
  const app = require('./src/app');
  app.listen(config.port, () => {
    logger.info('Farm2Door server started.', { url: `http://localhost:${config.port}` });
  });
}).catch((error) => {
  logger.error('Could not initialize the local database.', { message: error.message, stack: error.stack });
  process.exitCode = 1;
});