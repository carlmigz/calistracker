const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Program = sequelize.define(
    'Program',
    {
      id: { type: DataTypes.STRING, primaryKey: true },
      name: { type: DataTypes.STRING, allowNull: false },
      description: { type: DataTypes.TEXT, allowNull: false, defaultValue: '' },
      sortOrder: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 0 },
    },
    { tableName: 'programs' },
  );

  // Same shape as assets/data/programs.json, so the app can swap its data source.
  Program.prototype.toPublic = function toPublic() {
    return {
      id: this.id,
      name: this.name,
      description: this.description,
      exercises: (this.exercises || []).map((e) => e.toPublic()),
    };
  };

  return Program;
};
