exports.validateUpdateMe = (req, res, next) => {
  const name = req.body?.displayName;
  if (typeof name !== 'string' || !name.trim())
    return res.status(400).json({ error: 'Please enter your name.' });
  next();
};
