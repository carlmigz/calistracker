<?php

namespace App\Providers;

use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;
use Symfony\Component\HttpFoundation\Response;

class AppServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        $window = config('calistracker.rate_limit.window_minutes');

        // Applied to every request.
        RateLimiter::for('api', fn (Request $request) => $this->limit(
            $window,
            config('calistracker.rate_limit.max'),
            $request,
            'You\'re doing that too often. Please wait a moment and try again.',
        ));

        // Stricter limit for login and register, to slow down password guessing.
        RateLimiter::for('auth', fn (Request $request) => $this->limit(
            $window,
            config('calistracker.rate_limit.auth_max'),
            $request,
            'Too many attempts. Please wait a few minutes and try again.',
        ));
    }

    private function limit(int $minutes, int $max, Request $request, string $message): Limit
    {
        return Limit::perMinutes($minutes, $max)
            ->by($request->ip())
            ->response(fn (Request $req, array $headers): Response => response()->json(['error' => $message], 429, $headers));
    }
}
