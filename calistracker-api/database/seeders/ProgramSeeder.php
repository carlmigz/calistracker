<?php

namespace Database\Seeders;

use App\Models\Exercise;
use App\Models\Program;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use RuntimeException;

/** Imports programs and exercises from the Flutter app's assets/data/programs.json (safe to re-run). */
class ProgramSeeder extends Seeder
{
    public function run(): void
    {
        $file = $this->resolve(config('calistracker.programs_json'));
        if (! is_file($file)) {
            throw new RuntimeException("Programs file not found: {$file}");
        }

        $programs = json_decode(file_get_contents($file), true, flags: JSON_THROW_ON_ERROR)['programs'];

        DB::transaction(function () use ($programs) {
            foreach ($programs as $pi => $p) {
                Program::updateOrCreate(['id' => $p['id']], [
                    'name' => $p['name'],
                    'description' => $p['description'] ?? '',
                    'sort_order' => $pi,
                ]);

                foreach ($p['exercises'] as $ei => $e) {
                    Exercise::updateOrCreate(['id' => $e['id']], [
                        'program_id' => $p['id'],
                        'position' => $ei,
                        'name' => $e['name'],
                        'description' => $e['description'] ?? '',
                        'muscles' => $e['muscles'] ?? [],
                        'steps' => $e['steps'] ?? [],
                        'sets' => $e['sets'],
                        'reps' => $e['reps'] ?? null,
                        'hold_seconds' => $e['holdSeconds'] ?? null,
                        'pose_asset' => $e['poseAsset'] ?? null,
                    ]);
                }
            }
        });

        $this->command?->info(sprintf('Seeded %d programs from %s', count($programs), $file));
    }

    private function resolve(string $path): string
    {
        $absolute = preg_match('#^([A-Za-z]:[\\\\/]|/)#', $path) === 1;

        return $absolute ? $path : base_path($path);
    }
}
