const { ValidationError, UniqueConstraintError } = require('sequelize');
const logger = require('../utils/logger');

/** Lets controllers be plain async functions; rejections go to the error handler. */
const asyncHandler = (fn) => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

const notFound = (_req, res) => 
  res.status(404).json({ error: 'We couldn\'t find what you\'re looking for.' });

// eslint-disable-next-line no-unused-vars
function errorHandler(err, req, res, _next) {
  if (err.type === 'entity.parse.failed')
    return res.status(400).json({ error: 'Something was wrong with your request. Please try again.' });
  if (err instanceof UniqueConstraintError)
    return res.status(409).json({ error: 'That already exists.' });
  if (err instanceof ValidationError) {
    // Our model messages are full sentences ending in a period. Anything else is
    // Sequelize's own technical wording, so replace it with a generic message.
    const friendly = err.errors.map((e) => e.message).filter((m) => m.endsWith('.'));
    return res.status(400).json({
      error: friendly.length ? friendly.join(' ') : 'Please check what you entered and try again.',
    });
  }
  logger.error(`${req.method} ${req.originalUrl} failed: ${err.stack || err}`);
  res.status(500).json({ error: 'Something went wrong on our side. Please try again later.' });
}

module.exports = { asyncHandler, notFound, errorHandler };
