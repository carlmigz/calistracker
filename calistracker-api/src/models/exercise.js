const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Exercise = sequelize.define(
    'Exercise',
    {
      id: { type: DataTypes.STRING, primaryKey: true },
      programId: { type: DataTypes.STRING, allowNull: false },
      // Unlock order inside the program.
      position: { type: DataTypes.INTEGER, allowNull: false },
      name: { type: DataTypes.STRING, allowNull: false },
      description: { type: DataTypes.TEXT, allowNull: false, defaultValue: '' },
      muscles: { type: DataTypes.ARRAY(DataTypes.TEXT), allowNull: false, defaultValue: [] },
      steps: { type: DataTypes.ARRAY(DataTypes.TEXT), allowNull: false, defaultValue: [] },
      sets: { type: DataTypes.INTEGER, allowNull: false },
      // Rep-based exercises set reps; timed holds set holdSeconds.
      reps: { type: DataTypes.INTEGER, allowNull: true },
      holdSeconds: { type: DataTypes.INTEGER, allowNull: true },
      poseAsset: { type: DataTypes.STRING, allowNull: true },
    },
    {
      tableName: 'exercises',
      indexes: [{ unique: true, fields: ['program_id', 'position'] }],
    },
  );

  Exercise.prototype.toPublic = function toPublic() {
    return {
      id: this.id,
      name: this.name,
      description: this.description,
      muscles: this.muscles,
      steps: this.steps,
      sets: this.sets,
      ...(this.reps != null && { reps: this.reps }),
      ...(this.holdSeconds != null && { holdSeconds: this.holdSeconds }),
      ...(this.poseAsset != null && { poseAsset: this.poseAsset }),
    };
  };

  return Exercise;
};
