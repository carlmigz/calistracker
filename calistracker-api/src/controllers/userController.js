const { User } = require('../models');
const { asyncHandler } = require('../middleware/errorHandler');

exports.getMe = asyncHandler(async (req, res) => {
  const user = await User.findByPk(req.userId);
  if (!user) return res.status(404).json({ error: 'We couldn\'t find your account.' });
  res.json(user.toPublic());
});

// Input is checked beforehand by validators/userValidator.js.
exports.updateMe = asyncHandler(async (req, res) => {
  const user = await User.findByPk(req.userId);
  if (!user) return res.status(404).json({ error: 'We couldn\'t find your account.' });
  await user.update({ displayName: req.body.displayName.trim() });
  res.json(user.toPublic());
});
