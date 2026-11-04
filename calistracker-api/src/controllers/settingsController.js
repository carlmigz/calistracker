const { UserSettings } = require('../models');
const { asyncHandler } = require('../middleware/errorHandler');

const load = async (userId) => {
  const [settings] = await UserSettings.findOrCreate({ where: { userId } });
  return settings;
};

exports.get = asyncHandler(async (req, res) => {
  res.json((await load(req.userId)).toPublic());
});

// Partial update: send only the settings that changed.
// Unknown fields are rejected beforehand by validators/settingsValidator.js.
exports.update = asyncHandler(async (req, res) => {
  const settings = await load(req.userId);
  await settings.update(req.body || {}, { fields: UserSettings.EDITABLE });
  res.json(settings.toPublic());
});
