<?php

use Monolog\Handler\NullHandler;

// Console + storage/logs/combined.log (everything) + storage/logs/error.log (errors only).
// Each file rotates daily and keeps LOG_DAILY_DAYS files. Request bodies and passwords are never logged.
return [
    'default' => env('LOG_CHANNEL', 'stack'),

    'deprecations' => [
        'channel' => 'null',
        'trace' => false,
    ],

    'channels' => [
        'stack' => [
            'driver' => 'stack',
            'channels' => ['combined', 'error', 'stderr'],
            'ignore_exceptions' => false,
        ],

        'combined' => [
            'driver' => 'daily',
            'path' => storage_path('logs/combined.log'),
            'level' => env('LOG_LEVEL', 'info'),
            'days' => (int) env('LOG_DAILY_DAYS', 14),
            'replace_placeholders' => true,
        ],

        'error' => [
            'driver' => 'daily',
            'path' => storage_path('logs/error.log'),
            'level' => 'error',
            'days' => (int) env('LOG_DAILY_DAYS', 14),
            'replace_placeholders' => true,
        ],

        'stderr' => [
            'driver' => 'monolog',
            'level' => env('LOG_LEVEL', 'info'),
            'handler' => Monolog\Handler\StreamHandler::class,
            'handler_with' => ['stream' => 'php://stderr'],
            'formatter' => env('LOG_STDERR_FORMATTER'),
            'processors' => [Monolog\Processor\PsrLogMessageProcessor::class],
        ],

        'null' => [
            'driver' => 'monolog',
            'handler' => NullHandler::class,
        ],
    ],
];
