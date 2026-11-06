<?php

use Illuminate\Support\Str;

// The cache backs the rate limiter. `file` works out of the box; use `database` or `redis` if you run several servers.
return [
    'default' => env('CACHE_STORE', 'file'),

    'stores' => [
        'array' => [
            'driver' => 'array',
            'serialize' => false,
        ],
        'file' => [
            'driver' => 'file',
            'path' => storage_path('framework/cache/data'),
            'lock_path' => storage_path('framework/cache/data'),
        ],
    ],

    'prefix' => env('CACHE_PREFIX', Str::slug(env('APP_NAME', 'laravel'), '_').'_cache_'),
];
