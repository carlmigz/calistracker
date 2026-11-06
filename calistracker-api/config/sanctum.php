<?php

return [
    // Token-only API: no cookie/SPA (stateful) authentication.
    'stateful' => [],
    'guard' => [],

    // Token lifetime in minutes (default 30 days, like the old JWT_EXPIRES_IN=30d).
    'expiration' => (int) env('SANCTUM_TOKEN_EXPIRATION_MINUTES', 60 * 24 * 30),

    'token_prefix' => env('SANCTUM_TOKEN_PREFIX', ''),

    'middleware' => [
        'authenticate_session' => Laravel\Sanctum\Http\Middleware\AuthenticateSession::class,
        'encrypt_cookies' => Illuminate\Cookie\Middleware\EncryptCookies::class,
        'validate_csrf_token' => Illuminate\Foundation\Http\Middleware\ValidateCsrfToken::class,
    ],
];
