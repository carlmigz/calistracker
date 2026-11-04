const jwt = require('jsonwebtoken');
const config = require('../config');

const signToken = (userId) =>
  jwt.sign({ sub: String(userId) }, config.jwtSecret, { expiresIn: config.jwtExpiresIn });

function requireAuth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return res.status(401).json({ error: 'Please log in to continue.' });
  try {
    req.userId = jwt.verify(token, config.jwtSecret).sub;
    next();
  } catch {
    res.status(401).json({ error: 'Your session has expired. Please log in again.' });
  }
}

module.exports = { signToken, requireAuth };
