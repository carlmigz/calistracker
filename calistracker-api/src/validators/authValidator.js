const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const USERNAME = /^[a-zA-Z0-9_]{3,30}$/;

const bad = (res, error) => res.status(400).json({ error });

exports.validateRegister = (req, res, next) => {
  const { email, username, password } = req.body || {};
  if (typeof email !== 'string' || !EMAIL.test(email.trim()))
    return bad(res, 'Please enter a valid email address.');
  if (username != null && username !== '' && !(typeof username === 'string' && USERNAME.test(username.trim())))
    return bad(res, 'Username must be 3 to 30 characters, using only letters, numbers or underscores.');
  if (typeof password !== 'string' || password.length < 6)
    return bad(res, 'Your password must be at least 6 characters long.');
  next();
};

/** `identifier` is an email or username; `email` / `username` are accepted as aliases. */
exports.validateLogin = (req, res, next) => {
  const body = req.body || {};
  const identifier = String(body.identifier ?? body.email ?? body.username ?? '')
    .trim()
    .toLowerCase();
  if (!identifier) return bad(res, 'Please enter your email or username.');
  if (typeof body.password !== 'string' || !body.password) return bad(res, 'Please enter your password.');
  req.credentials = { identifier, password: body.password };
  next();
};
