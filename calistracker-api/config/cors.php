<?php

// CORS_ORIGIN: comma-separated origins, or * to allow any.
return [
    'paths' => ['*'],
    'allowed_methods' => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    'allowed_origins' => array_values(array_filter(array_map('trim', explode(',', env('CORS_ORIGIN', '*'))))),
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['Content-Type', 'Authorization', 'Accept'],
    'exposed_headers' => ['Retry-After', 'X-RateLimit-Limit', 'X-RateLimit-Remaining'],
    'max_age' => 0,
    'supports_credentials' => false,
];
