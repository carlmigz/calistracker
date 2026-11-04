const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const config = require('./config');
const { sequelize } = require('./models');
const routes = require('./routes');
const { apiLimiter } = require('./middleware/rateLimit');
const requestLogger = require('./middleware/requestLogger');
const logger = require('./utils/logger');
const { notFound, errorHandler } = require('./middleware/errorHandler');

const app = express();

app.use(
  cors({
    origin: config.corsOrigin.includes('*') ? true : config.corsOrigin,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  }),
);
// Only enable behind a reverse proxy, so the limiter sees the real client IP.
if (config.trustProxy) app.set('trust proxy', 1);

app.use(helmet());
app.use(requestLogger);
app.use(apiLimiter);
app.use(express.json());

app.get('/health', async (_req, res) => {
  try {
    await sequelize.authenticate();
    res.json({ status: 'ok', database: 'connected' });
  } catch (e) {
    logger.error(`Health check failed: ${e.message}`);
    res.status(503).json({
      status: 'degraded',
      database: 'unavailable',
      message: 'The service is having trouble right now. Please try again later.',
    });
  }
});

app.use(routes);
app.use(notFound);
app.use(errorHandler);

module.exports = app;
