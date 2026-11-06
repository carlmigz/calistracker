<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

/** One log line per request (method, URL, status, time). Bodies are never logged. */
class LogRequest
{
    public function handle(Request $request, Closure $next): Response
    {
        $start = microtime(true);
        $response = $next($request);

        Log::info(sprintf(
            '%s %s %d - %.1f ms',
            $request->method(),
            $request->getRequestUri(),
            $response->getStatusCode(),
            (microtime(true) - $start) * 1000,
        ));

        return $response;
    }
}
