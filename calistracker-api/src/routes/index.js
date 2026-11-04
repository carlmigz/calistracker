const express = require('express');
const { requireAuth } = require('../middleware/auth');
const { authLimiter } = require('../middleware/rateLimit');
const auth = require('../controllers/authController');
const programs = require('../controllers/programController');
const user = require('../controllers/userController');
const settings = require('../controllers/settingsController');
const completions = require('../controllers/completionController');
const { validateRegister, validateLogin } = require('../validators/authValidator');
const { validateUpdateMe } = require('../validators/userValidator');
const { validateUpdateSettings } = require('../validators/settingsValidator');
const { validateCreateCompletion } = require('../validators/completionValidator');

const router = express.Router();

router.post('/auth/register', authLimiter, validateRegister, auth.register);
router.post('/auth/login', authLimiter, validateLogin, auth.login);

router.get('/programs', programs.list);
router.get('/programs/:id', programs.get);

const me = express.Router();
me.use(requireAuth);
me.get('/', user.getMe);
me.patch('/', validateUpdateMe, user.updateMe);
me.get('/settings', settings.get);
me.put('/settings', validateUpdateSettings, settings.update);
me.get('/completions', completions.list);
me.post('/completions', validateCreateCompletion, completions.create);
me.delete('/completions/:id', completions.remove);
router.use('/me', me);

module.exports = router;
