const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Completion = sequelize.define(
    'Completion',
    {
      id: { type: DataTypes.BIGINT, primaryKey: true, autoIncrement: true },
      userId: { type: DataTypes.BIGINT, allowNull: false },
      exerciseId: { type: DataTypes.STRING, allowNull: false },
      completedAt: { type: DataTypes.DATE, allowNull: false, defaultValue: DataTypes.NOW },
    },
    {
      tableName: 'completions',
      indexes: [{ fields: ['user_id', 'completed_at'] }],
    },
  );

  Completion.prototype.toPublic = function toPublic() {
    return { id: this.id, exerciseId: this.exerciseId, completedAt: this.completedAt };
  };

  return Completion;
};
