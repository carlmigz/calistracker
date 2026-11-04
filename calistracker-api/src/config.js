const path = require('path');
require('dotenv').config();

const env = process.env.NODE_ENV || 'development';

// Refuse to start in production with an unset or placeholder secret, since anyone could forge login tokens.
if (env === 'production') {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret === 'change-me' || secret.length < 32)
    throw new Error('Set JWT_SECRET in .env to a random string of at least 32 characters.');
}

module.exports = {
  env,
  port: Number(process.env.PORT) || 3000,
  // Use DATABASE_URL if set, otherwise the separate DB_* values.
  databaseUrl: process.env.DATABASE_URL || null,
  db: {
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 5432,
    name: process.env.DB_NAME || 'calistracker',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
  },
  databaseSsl: process.env.DATABASE_SSL === 'true',
  databaseLogging: process.env.DATABASE_LOGGING === 'true',
  logLevel: process.env.LOG_LEVEL || 'http',
  logDir: path.resolve(__dirname, '..', process.env.LOG_DIR || 'logs'),
  corsOrigin: (process.env.CORS_ORIGIN || '*')
    .split(',')
    .map((o) => o.trim())
    .filter(Boolean),
  trustProxy: process.env.TRUST_PROXY === 'true',
  rateLimit: {
    windowMs: (Number(process.env.RATE_LIMIT_WINDOW_MINUTES) || 15) * 60 * 1000,
    max: Number(process.env.RATE_LIMIT_MAX) || 300,
    authMax: Number(process.env.RATE_LIMIT_AUTH_MAX) || 20,
  },
  jwtSecret: process.env.JWT_SECRET || 'dev-only-secret',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '30d',
  programsJson: process.env.PROGRAMS_JSON || '../assets/data/programs.json',
};
