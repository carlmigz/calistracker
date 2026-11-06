# calistracker-api

REST API for CalisTracker. Laravel 12 + Sanctum (bearer tokens) + PostgreSQL.

## Setup

1. Install PHP 8.2+ (with `pdo_pgsql`), Composer and PostgreSQL, then create a database: `createdb calistracker`
2. `composer install`
3. Copy `.env.example` to `.env`, then `php artisan key:generate`
4. Set `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` (or `DB_URL` instead) in `.env`
5. `php artisan migrate --seed` (creates the tables, then seeds programs and exercises from `../assets/data/programs.json`)
6. `php artisan serve --host=0.0.0.0`, then open http://localhost:8000/health

From the Android emulator, reach it at `http://10.0.2.2:8000`. (The old Node API used port 3000.)

Re-run `php artisan db:seed` any time `programs.json` changes (it updates in place). `php artisan migrate:fresh --seed` drops everything and starts over.

## Structure

```
app/
  Models/              User, UserSettings, Program, Exercise, Completion
  Http/Controllers/    request handling, one file per resource
  Http/Requests/       input checks that run before a controller (errors become 400 {"error": ...})
  Http/Middleware/     LogRequest
  Providers/           AppServiceProvider (rate limiters)
bootstrap/app.php      middleware (trim, throttle, proxies) and JSON error rendering
config/                laravel config + calistracker.php (rate limits, programs.json path)
database/              migrations and the ProgramSeeder
routes/api.php         URL -> controller mapping (served at the root, no /api prefix)
tests/Feature/         php artisan test (SQLite in memory, no PostgreSQL needed)
storage/logs/          combined and error logs (git-ignored)
```

## Logs

Written to the console (stderr) and to `storage/logs/combined.log` (everything) and `storage/logs/error.log` (errors only), rotated daily (`LOG_DAILY_DAYS`). Every request gets one line (method, URL, status, time); request bodies and passwords are never logged. Failed logins, registrations and server errors are logged too. Set `LOG_LEVEL` in `.env`.

## CORS

Set `CORS_ORIGIN` in `.env` to a comma-separated list of origins (for example `http://localhost:5173,http://localhost:8080`), or `*` to allow any.

## Rate limiting

Per IP. Over the limit, the API returns `429 {"error": ...}` with `Retry-After` and `X-RateLimit-*` headers. Defaults, set in `.env`:

- All requests: 300 per 15 minutes (`RATE_LIMIT_MAX`, `RATE_LIMIT_WINDOW_MINUTES`)
- `/auth/register` and `/auth/login`: 20 per 15 minutes (`RATE_LIMIT_AUTH_MAX`), counted in addition to the global limit

Counts are kept in the cache (`CACHE_STORE`, `file` by default). Set `TRUST_PROXY=true` only behind a reverse proxy.

## Endpoints

| Method | Path | Auth | Notes |
|---|---|---|---|
| GET | `/health` | no | DB connectivity check |
| POST | `/auth/register` | no | `{email, password, username?, displayName?}` returns `{token, user}`. Username: 3-30 letters, numbers or `_` |
| POST | `/auth/login` | no | `{identifier, password}` where `identifier` is the email or the username. `email` or `username` are accepted in its place. Returns `{token, user}` |
| GET | `/programs` | no | Same shape as `programs.json` |
| GET | `/programs/{id}` | no | One program with its ordered exercises |
| GET / PATCH | `/me` | yes | PATCH `{displayName}` |
| GET / PUT | `/me/settings` | yes | PUT is partial: `themeMode`, `weeklyGoal`, `dailyGoal`, `avatarColorIndex`, `avatarAsset`, `hapticsEnabled`, `soundEnabled`, `defaultRestSeconds`, `onboardingSeen` |
| GET | `/me/completions` | yes | All completions, oldest first |
| POST | `/me/completions` | yes | `{exerciseId, completedAt?}` (ISO string or epoch millis; defaults to now) |
| DELETE | `/me/completions/{id}` | yes | |

Send `Authorization: Bearer <token>` on authenticated routes. Tokens expire after 30 days (`SANCTUM_TOKEN_EXPIRATION_MINUTES`). Every error is `{"error": "..."}`.

## Tables

`users`, `user_settings`, `programs`, `exercises`, `completions`, `personal_access_tokens` (Sanctum). Streaks, levels, weekly activity and achievements are derived from `completions` by the app and are not stored. `exercises.muscles` and `exercises.steps` are `jsonb` arrays.
