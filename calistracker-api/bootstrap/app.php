<?php

use App\Http\Middleware\LogRequest;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        // Routes live at the root (no /api prefix) to match the existing contract.
        api: __DIR__.'/../routes/api.php',
        apiPrefix: '',
        commands: __DIR__.'/../routes/console.php',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Passwords must not be trimmed; every other string input is.
        $middleware->trimStrings(except: ['password']);

        // Only enable behind a reverse proxy, so the limiter sees the real client IP.
        if (filter_var(env('TRUST_PROXY', false), FILTER_VALIDATE_BOOLEAN)) {
            $middleware->trustProxies(at: '*');
        }

        // Global per-IP limit (the "api" limiter is defined in AppServiceProvider).
        $middleware->throttleApi();
        $middleware->api(prepend: [LogRequest::class]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        // Every response is JSON in the shape {"error": "..."}.
        $exceptions->shouldRenderJsonWhen(fn () => true);

        $exceptions->render(function (AuthenticationException $e, Request $request) {
            $message = $request->bearerToken()
                ? 'Your session has expired. Please log in again.'
                : 'Please log in to continue.';

            return response()->json(['error' => $message], 401);
        });

        $exceptions->render(function (UniqueConstraintViolationException $e) {
            return response()->json(['error' => 'That already exists.'], 409);
        });

        $exceptions->render(function (HttpExceptionInterface $e) {
            // Unknown URLs and wrong methods both look like "not found" to clients.
            $status = $e->getStatusCode() === 405 ? 404 : $e->getStatusCode();
            $message = match (true) {
                $status === 400 => 'Something was wrong with your request. Please try again.',
                $status >= 500 => 'Something went wrong on our side. Please try again later.',
                default => 'We couldn\'t find what you\'re looking for.',
            };

            return response()->json(['error' => $message], $status);
        });

        $exceptions->render(function (Throwable $e) {
            // Anything unexpected: log is handled by Laravel's reporter, reply generically.
            if (config('app.debug')) {
                return null;
            }

            return response()->json(['error' => 'Something went wrong on our side. Please try again later.'], 500);
        });
    })->create();
