/** Checks the body and puts the parsed date on `req.completedAt` (undefined means "now"). */
exports.validateCreateCompletion = (req, res, next) => {
  const { exerciseId, completedAt } = req.body || {};
  if (typeof exerciseId !== 'string' || !exerciseId)
    return res.status(400).json({ error: 'Please choose an exercise.' });

  if (completedAt != null) {
    const when = new Date(completedAt);
    if (Number.isNaN(when.getTime()))
      return res.status(400).json({ error: 'The date you entered isn\'t valid.' });
    req.completedAt = when;
  }
  next();
};
