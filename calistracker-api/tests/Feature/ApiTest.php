<?php

namespace Tests\Feature;

use App\Models\Exercise;
use App\Models\Program;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiTest extends TestCase
{
    use RefreshDatabase;

    private function register(array $overrides = []): array
    {
        $res = $this->postJson('/auth/register', array_merge([
            'email' => 'Carlos@Example.com',
            'username' => 'Carlos_1',
            'password' => 'secret123',
        ], $overrides));

        return [$res, $res->json('token')];
    }

    private function seedProgram(): void
    {
        Program::create(['id' => 'push', 'name' => 'Push', 'description' => 'd', 'sort_order' => 0]);
        Exercise::create([
            'id' => 'push_wall', 'program_id' => 'push', 'position' => 0, 'name' => 'Wall Push-Up',
            'description' => 'd', 'muscles' => ['Chest'], 'steps' => ['one'], 'sets' => 3, 'reps' => 12,
        ]);
        Exercise::create([
            'id' => 'push_hold', 'program_id' => 'push', 'position' => 1, 'name' => 'Hold',
            'description' => 'd', 'muscles' => [], 'steps' => [], 'sets' => 2, 'hold_seconds' => 20,
        ]);
    }

    public function test_unknown_route_returns_404(): void
    {
        $this->getJson('/nope')->assertNotFound()->assertJsonStructure(['error']);
    }

    public function test_malformed_json_returns_400(): void
    {
        $this->call('POST', '/auth/login', [], [], [], [
            'CONTENT_TYPE' => 'application/json', 'HTTP_ACCEPT' => 'application/json',
        ], '{bad')->assertStatus(400);
    }

    public function test_protected_routes_need_a_valid_token(): void
    {
        $this->getJson('/me')->assertUnauthorized()->assertExactJson(['error' => 'Please log in to continue.']);
        $this->getJson('/me/settings', ['Authorization' => 'Bearer nope'])->assertUnauthorized();
    }

    public function test_register_rejects_bad_input(): void
    {
        foreach ([
            ['email' => 'not-an-email', 'password' => 'secret123'],
            ['email' => 'a@b.com', 'password' => '123'],
            ['email' => 'a@b.com', 'password' => 'secret123', 'username' => 'x'],
        ] as $body) {
            $this->postJson('/auth/register', $body)->assertStatus(400)->assertJsonStructure(['error']);
        }
    }

    public function test_login_needs_an_identifier_and_a_password(): void
    {
        $this->postJson('/auth/login', ['password' => 'secret123'])->assertStatus(400);
        $this->postJson('/auth/login', ['identifier' => 'carlos'])->assertStatus(400);
    }

    public function test_register_and_login_flow(): void
    {
        [$res] = $this->register();
        $res->assertCreated()->assertJsonPath('user.email', 'carlos@example.com')
            ->assertJsonPath('user.username', 'carlos_1')->assertJsonPath('user.displayName', 'Athlete');

        $this->register()[0]->assertStatus(409);

        foreach (['carlos@example.com', 'CARLOS_1'] as $identifier) {
            $this->postJson('/auth/login', ['identifier' => $identifier, 'password' => 'secret123'])
                ->assertOk()->assertJsonStructure(['token', 'user' => ['id', 'email', 'username', 'displayName']]);
        }
        $this->postJson('/auth/login', ['email' => 'carlos@example.com', 'password' => 'secret123'])->assertOk();
        $this->postJson('/auth/login', ['identifier' => 'carlos_1', 'password' => 'wrong'])->assertUnauthorized();
    }

    public function test_me_and_settings(): void
    {
        [, $token] = $this->register(['displayName' => ' Carlos ']);
        $h = ['Authorization' => "Bearer {$token}"];

        $this->getJson('/me', $h)->assertOk()->assertJsonPath('displayName', 'Carlos');
        $this->patchJson('/me', ['displayName' => '  '], $h)->assertStatus(400);
        $this->patchJson('/me', ['displayName' => ' Sam '], $h)->assertOk()->assertJsonPath('displayName', 'Sam');

        $this->getJson('/me/settings', $h)->assertOk()->assertExactJson([
            'themeMode' => 'system', 'weeklyGoal' => 3, 'dailyGoal' => 3, 'avatarColorIndex' => 0,
            'avatarAsset' => '', 'hapticsEnabled' => true, 'soundEnabled' => false,
            'defaultRestSeconds' => 60, 'onboardingSeen' => false,
        ]);

        $this->putJson('/me/settings', ['themeMode' => 'dark', 'weeklyGoal' => 5, 'soundEnabled' => true], $h)
            ->assertOk()->assertJsonPath('themeMode', 'dark')->assertJsonPath('weeklyGoal', 5)
            ->assertJsonPath('soundEnabled', true)->assertJsonPath('dailyGoal', 3);
        $this->putJson('/me/settings', ['weeklyGoal' => 9], $h)->assertStatus(400);
        $this->putJson('/me/settings', ['themeMode' => 'neon'], $h)->assertStatus(400);
        $this->putJson('/me/settings', ['isAdmin' => true], $h)->assertStatus(400);
    }

    public function test_programs_are_public_and_ordered(): void
    {
        $this->seedProgram();

        $this->getJson('/programs')->assertOk()->assertJsonPath('programs.0.id', 'push')
            ->assertJsonPath('programs.0.exercises.0.id', 'push_wall')
            ->assertJsonPath('programs.0.exercises.0.reps', 12)
            ->assertJsonMissingPath('programs.0.exercises.0.holdSeconds')
            ->assertJsonPath('programs.0.exercises.1.holdSeconds', 20);
        $this->getJson('/programs/push')->assertOk()->assertJsonCount(2, 'exercises');
        $this->getJson('/programs/missing')->assertNotFound();
    }

    public function test_completions(): void
    {
        $this->seedProgram();
        [, $token] = $this->register();
        [, $other] = $this->register(['email' => 'b@example.com', 'username' => 'bee']);
        $h = ['Authorization' => "Bearer {$token}"];

        $this->postJson('/me/completions', [], $h)->assertStatus(400);
        $this->postJson('/me/completions', ['exerciseId' => 'nope'], $h)->assertNotFound();
        $this->postJson('/me/completions', ['exerciseId' => 'push_wall', 'completedAt' => 'garbage'], $h)->assertStatus(400);

        $this->postJson('/me/completions', ['exerciseId' => 'push_wall', 'completedAt' => '2026-01-02T03:04:05Z'], $h)
            ->assertCreated()->assertJsonPath('completedAt', '2026-01-02T03:04:05.000Z');
        $this->postJson('/me/completions', ['exerciseId' => 'push_hold', 'completedAt' => 1700000000000], $h)
            ->assertCreated()->assertJsonPath('completedAt', '2023-11-14T22:13:20.000Z');
        $id = $this->postJson('/me/completions', ['exerciseId' => 'push_wall'], $h)->assertCreated()->json('id');

        $list = $this->getJson('/me/completions', $h)->assertOk()->assertJsonCount(3, 'completions');
        // Oldest first: 2023, then 2026-01-02, then "now".
        $this->assertSame('2026-01-02T03:04:05.000Z', $list->json('completions.1.completedAt'));

        $this->getJson('/me/completions', ['Authorization' => "Bearer {$other}"])->assertJsonCount(0, 'completions');
        $this->deleteJson("/me/completions/{$id}", [], ['Authorization' => "Bearer {$other}"])->assertNotFound();
        $this->deleteJson('/me/completions/abc', [], $h)->assertNotFound();
        $this->deleteJson("/me/completions/{$id}", [], $h)->assertNoContent();
    }

    public function test_health_reports_ok(): void
    {
        $this->getJson('/health')->assertOk()->assertExactJson(['status' => 'ok', 'database' => 'connected']);
    }
}
