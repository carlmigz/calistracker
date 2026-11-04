const morgan = require('morgan');
const logger = require('../utils/logger');

// One line per request (method, URL, status, size, time). Bodies are never logged.
module.exports = morgan(':method :url :status :res[content-length] - :response-time ms', {
  stream: { write: (line) => logger.http(line.trim()) },
});
