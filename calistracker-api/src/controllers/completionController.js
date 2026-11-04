const { Completion, Exercise } = require('../models');
const { asyncHandler } = require('../middleware/errorHandler');

exports.list = asyncHandler(async (req, res) => {
  const completions = await Completion.findAll({
    where: { userId: req.userId },
    order: [['completedAt', 'ASC'], ['id', 'ASC']],
  });
  res.json({ completions: completions.map((c) => c.toPublic()) });
});

// Input is checked beforehand by validators/completionValidator.js.
exports.create = asyncHandler(async (req, res) => {
  const { exerciseId } = req.body;
  if (!(await Exercise.findByPk(exerciseId)))
    return res.status(404).json({ error: 'We couldn\'t find that exercise.' });

  const completion = await Completion.create({
    userId: req.userId,
    exerciseId,
    ...(req.completedAt && { completedAt: req.completedAt }),
  });
  res.status(201).json(completion.toPublic());
});

exports.remove = asyncHandler(async (req, res) => {
  const notFound = { error: 'We couldn\'t find that workout record.' };
  if (!/^\d+$/.test(req.params.id)) return res.status(404).json(notFound);
  const deleted = await Completion.destroy({
    where: { id: req.params.id, userId: req.userId },
  });
  if (!deleted) return res.status(404).json(notFound);
  res.status(204).end();
});
