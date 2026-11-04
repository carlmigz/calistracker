// Imports programs and exercises from the Flutter app's assets/data/programs.json.
const fs = require('fs');
const path = require('path');
const config = require('../src/config');
const { sequelize, Program, Exercise } = require('../src/models');

(async () => {
  const file = path.resolve(__dirname, '..', config.programsJson);
  try {
    const { programs } = JSON.parse(fs.readFileSync(file, 'utf8'));
    await sequelize.transaction(async (transaction) => {
      for (const [pi, p] of programs.entries()) {
        await Program.upsert(
          { id: p.id, name: p.name, description: p.description ?? '', sortOrder: pi },
          { transaction },
        );
        for (const [ei, e] of p.exercises.entries()) {
          await Exercise.upsert(
            {
              id: e.id,
              programId: p.id,
              position: ei,
              name: e.name,
              description: e.description ?? '',
              muscles: e.muscles ?? [],
              steps: e.steps ?? [],
              sets: e.sets,
              reps: e.reps ?? null,
              holdSeconds: e.holdSeconds ?? null,
              poseAsset: e.poseAsset ?? null,
            },
            { transaction },
          );
        }
      }
    });
    console.log(`Seeded ${programs.length} programs from ${file}`);
  } catch (e) {
    console.error('Seed failed:', e.message);
    process.exitCode = 1;
  } finally {
    await sequelize.close();
  }
})();
