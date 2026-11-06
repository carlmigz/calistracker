<?php

// This API returns only JSON, but the framework expects these paths to exist.
return [
    'paths' => [resource_path('views')],
    'compiled' => env('VIEW_COMPILED_PATH', realpath(storage_path('framework/views'))),
];
