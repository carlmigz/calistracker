<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CompletionController;
use App\Http\Controllers\ProgramController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Route;

Route::get('/health', function () {
    try {
        DB::connection()->getPdo();

        return response()->json(['status' => 'ok', 'database' => 'connected']);
    } catch (Throwable $e) {
        Log::error("Health check failed: {$e->getMessage()}");

        return response()->json([
            'status' => 'degraded',
            'database' => 'unavailable',
            'message' => 'The service is having trouble right now. Please try again later.',
        ], 503);
    }
});

Route::middleware('throttle:auth')->prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
});

Route::get('/programs', [ProgramController::class, 'index']);
Route::get('/programs/{id}', [ProgramController::class, 'show']);

Route::middleware('auth:sanctum')->prefix('me')->group(function () {
    Route::get('/', [UserController::class, 'show']);
    Route::patch('/', [UserController::class, 'update']);
    Route::get('/settings', [SettingsController::class, 'show']);
    Route::put('/settings', [SettingsController::class, 'update']);
    Route::get('/completions', [CompletionController::class, 'index']);
    Route::post('/completions', [CompletionController::class, 'store']);
    Route::delete('/completions/{id}', [CompletionController::class, 'destroy']);
});
