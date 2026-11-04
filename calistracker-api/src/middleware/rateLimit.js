const rateLimit = require('express-rate-limit');
const config = require('../config');

const make = (windowMs, limit, message) =>
  rateLimit({
    windowMs,
    limit,
    standardHeaders: 'draft-7', // RateLimit-* response headers
    legacyHeaders: false,
    message: { error: message },
  });

/** Applied to every request. */
const apiLimiter = make(
  config.rateLimit.windowMs,
  config.rateLimit.max,
  'You\'re doing that too often. Please wait a moment and try again.',
);

/** Stricter limit for login and register to slow down password guessing. */
const authLimiter = make(
  config.rateLimit.windowMs,
  config.rateLimit.authMax,
  'Too many attempts. Please wait a few minutes and try again.',
);

module.exports = { apiLimiter, authLimiter };
