const { UserSettings } = require('../models');

/** Rejects unknown fields; value rules (ranges, allowed themes) live in the model. */
exports.validateUpdateSettings = (req, res, next) => {
  const unknown = Object.keys(req.body || {}).find((k) => !UserSettings.EDITABLE.includes(k));
  if (unknown) return res.status(400).json({ error: 'One of those settings can\'t be changed.' });
  next();
};
