const fs = require('fs');
const path = require('path');
const { createLogger, format, transports } = require('winston');
const config = require('../config');

const isTest = config.env === 'test';
const fileFormat = format.combine(format.timestamp(), format.errors({ stack: true }), format.json());
const consoleFormat = format.combine(
  format.colorize(),
  format.timestamp({ format: 'HH:mm:ss' }),
  format.printf(({ timestamp, level, message, stack }) => `${timestamp} ${level} ${stack || message}`),
);

const logTransports = [new transports.Console({ format: consoleFormat, silent: isTest })];

if (!isTest) {
  fs.mkdirSync(config.logDir, { recursive: true });
  // Files rotate by size: up to 5 files of 5 MB each.
  const rotation = { maxsize: 5 * 1024 * 1024, maxFiles: 5, format: fileFormat };
  logTransports.push(
    new transports.File({ filename: path.join(config.logDir, 'error.log'), level: 'error', ...rotation }),
    new transports.File({ filename: path.join(config.logDir, 'combined.log'), ...rotation }),
  );
}

// Levels: error, warn, info, http, verbose, debug, silly
module.exports = createLogger({ level: config.logLevel, transports: logTransports });
