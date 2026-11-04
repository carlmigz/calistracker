const { Program, Exercise } = require('../models');
const { asyncHandler } = require('../middleware/errorHandler');

const include = [{ model: Exercise, as: 'exercises' }];
const exerciseOrder = [{ model: Exercise, as: 'exercises' }, 'position', 'ASC'];

exports.list = asyncHandler(async (_req, res) => {
  const programs = await Program.findAll({
    include,
    order: [['sortOrder', 'ASC'], ['id', 'ASC'], exerciseOrder],
  });
  res.json({ programs: programs.map((p) => p.toPublic()) });
});

exports.get = asyncHandler(async (req, res) => {
  const program = await Program.findByPk(req.params.id, { include, order: [exerciseOrder] });
  if (!program) return res.status(404).json({ error: 'We couldn\'t find that program.' });
  res.json(program.toPublic());
});
