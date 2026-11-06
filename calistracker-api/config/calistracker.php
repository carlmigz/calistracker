<?php

return [
    // Rate limiting, per IP: all requests, and login/register separately (counted in addition).
    'rate_limit' => [
        'window_minutes' => (int) env('RATE_LIMIT_WINDOW_MINUTES', 15),
        'max' => (int) env('RATE_LIMIT_MAX', 300),
        'auth_max' => (int) env('RATE_LIMIT_AUTH_MAX', 20),
    ],

    // The Flutter app's content file, used by the ProgramSeeder (relative to the project folder).
    'programs_json' => env('PROGRAMS_JSON', '../assets/data/programs.json'),
];
