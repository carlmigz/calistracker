const bcrypt = require('bcryptjs');
const { Op } = require('sequelize');
const { sequelize, User, UserSettings } = require('../models');
const { signToken } = require('../middleware/auth');
const { asyncHandler } = require('../middleware/errorHandler');
const logger = require('../utils/logger');

// Input is checked beforehand by validators/authValidator.js.
exports.register = asyncHandler(async (req, res) => {
  const { email, username, password, displayName } = req.body;
  const name = typeof displayName === 'string' ? displayName.trim() : '';
  const passwordHash = await bcrypt.hash(password, 10);

  try {
    const user = await sequelize.transaction(async (transaction) => {
      const created = await User.create(
        { email, username, passwordHash, ...(name && { displayName: name }) },
        { transaction },
      );
      await UserSettings.create({ userId: created.id }, { transaction });
      return created;
    });
    logger.info(`User registered: id=${user.id}`);
    res.status(201).json({ token: signToken(user.id), user: user.toPublic() });
  } catch (e) {
    if (e.name === 'SequelizeUniqueConstraintError')
      return res.status(409).json({ error: 'That email or username is already taken.' });
    throw e;
  }
});

exports.login = asyncHandler(async (req, res) => {
  const { identifier, password } = req.credentials;
  const user = await User.findOne({
    where: { [Op.or]: [{ email: identifier }, { username: identifier }] },
  });
  if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
    logger.warn(`Failed login attempt from ${req.ip}`);
    return res.status(401).json({ error: 'Incorrect email, username or password.' });
  }
  logger.info(`User logged in: id=${user.id}`);
  res.json({ token: signToken(user.id), user: user.toPublic() });
});
