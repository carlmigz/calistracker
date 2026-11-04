// Runs with Node's built-in test runner: npm test
// These cover routing, auth and input validation, which all reject before the database is touched.
process.env.NODE_ENV = 'test';

const test = require('node:test');
const assert = require('node:assert/strict');
const app = require('../src/app');
const { sequelize } = require('../src/models');

let server;
let base;

test.before(
  () =>
    new Promise((resolve) => {
      server = app.listen(0, () => {
        base = `http://127.0.0.1:${server.address().port}`;
        resolve();
      });
    }),
);

test.after(async () => {
  await new Promise((resolve) => server.close(resolve));
  await sequelize.close();
});

const send = (method, path, body, headers = {}) =>
  fetch(base + path, {
    method,
    headers: { 'Content-Type': 'application/json', ...headers },
    body: body === undefined ? undefined : JSON.stringify(body),
  });

test('unknown route returns 404', async () => {
  assert.equal((await send('GET', '/nope')).status, 404);
});

test('malformed JSON returns 400', async () => {
  const res = await fetch(`${base}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: '{bad',
  });
  assert.equal(res.status, 400);
});

test('protected routes need a valid token', async () => {
  assert.equal((await send('GET', '/me')).status, 401);
  assert.equal((await send('GET', '/me/settings', undefined, { Authorization: 'Bearer nope' })).status, 401);
});

test('register rejects bad input', async () => {
  const bad = [
    { email: 'not-an-email', password: 'secret123' },
    { email: 'a@b.com', password: '123' },
    { email: 'a@b.com', password: 'secret123', username: 'x' },
  ];
  for (const body of bad) assert.equal((await send('POST', '/auth/register', body)).status, 400);
});

test('login needs an identifier and a password', async () => {
  assert.equal((await send('POST', '/auth/login', { password: 'secret123' })).status, 400);
  assert.equal((await send('POST', '/auth/login', { identifier: 'carlos' })).status, 400);
});
