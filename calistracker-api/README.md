# calistracker-api

Local REST API for CalisTracker. Node.js + Express + Sequelize + PostgreSQL.

## Setup

1. Install Node 18+ and PostgreSQL, then create a database: `createdb calistracker`
2. `npm install`
3. Copy `.env.example` to `.env` and set `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` (or `DATABASE_URL` instead) and `JWT_SECRET`
4. `npm run db:setup` (creates the tables from the models, then seeds programs and exercises from `../assets/data/programs.json`)
5. `npm run dev` (or `npm start`), then open http://localhost:3000/health

The server starts even if the database is down; `/health` reports the connection state.
From the Android emulator, reach it at `http://10.0.2.2:3000`.

After changing a model, run `node scripts/migrate.js --alter` to update the tables (`--force` drops and recreates them).

## Structure

```
src/
  config.js            env settings
  db.js                Sequelize instance
  models/              User, UserSettings, Program, Exercise, Completion (+ associations in index.js)
  controllers/         request handling, one file per resource
  validators/          input checks that run before a controller
  routes/index.js      URL -> controller mapping
  middleware/          auth (JWT), rateLimit, requestLogger, errorHandler (+ asyncHandler)
  utils/               logger (winston)
  app.js               Express app (CORS, logging, rate limit, JSON, routes)
  server.js            starts the server
scripts/               migrate.js, seed.js
tests/                 npm test (Node's built-in runner, no database needed)
logs/                  error.log and combined.log (git-ignored)
```

## Logs

Written with winston to the console and to `logs/error.log` (errors only) and `logs/combined.log` (everything). Each file rotates at 5 MB and keeps 5 files. Every request gets one line (method, URL, status, time); request bodies and passwords are never logged. Failed logins, registrations and server errors are logged too. Set `LOG_LEVEL` (`error`, `warn`, `info`, `http`, `debug`) and `LOG_DIR` in `.env`.

## CORS

Set `CORS_ORIGIN` in `.env` to a comma-separated list of origins (for example `http://localhost:5173,http://localhost:8080`), or `*` to allow any.

## Rate limiting

Per IP, using `express-rate-limit`. Over the limit, the API returns `429 {"error": ...}` with `RateLimit-*` headers. Defaults, set in `.env`:

- All requests: 300 per 15 minutes (`RATE_LIMIT_MAX`, `RATE_LIMIT_WINDOW_MINUTES`)
- `/auth/register` and `/auth/login`: 20 per 15 minutes (`RATE_LIMIT_AUTH_MAX`), counted in addition to the global limit

Counts are kept in memory and reset when the server restarts. Set `TRUST_PROXY=true` only behind a reverse proxy.

## Endpoints

| Method | Path | Auth | Notes |
|---|---|---|---|
| GET | `/health` | no | DB connectivity check |
| POST | `/auth/register` | no | `{email, password, username?, displayName?}` returns `{token, user}`. Username: 3-30 letters, numbers or `_` |
| POST | `/auth/login` | no | `{identifier, password}` where `identifier` is the email or the username. `email` or `username` are accepted in its place. Returns `{token, user}` |
| GET | `/programs` | no | Same shape as `programs.json` |
| GET | `/programs/:id` | no | One program with its ordered exercises |
| GET / PATCH | `/me` | yes | PATCH `{displayName}` |
| GET / PUT | `/me/settings` | yes | PUT is partial: `themeMode`, `weeklyGoal`, `dailyGoal`, `avatarColorIndex`, `avatarAsset`, `hapticsEnabled`, `soundEnabled`, `defaultRestSeconds`, `onboardingSeen` |
| GET | `/me/completions` | yes | All completions, oldest first |
| POST | `/me/completions` | yes | `{exerciseId, completedAt?}` (ISO string or epoch millis; defaults to now) |
| DELETE | `/me/completions/:id` | yes | |

Send `Authorization: Bearer <token>` on authenticated routes.

## Tables

`users`, `user_settings`, `programs`, `exercises`, `completions`. Streaks, levels, weekly activity and achievements are derived from `completions` by the app and are not stored.
