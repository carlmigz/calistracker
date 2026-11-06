<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\User;
use App\Models\UserSettings;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    // Input is checked beforehand by RegisterRequest.
    public function register(RegisterRequest $request): JsonResponse
    {
        $name = $request->input('displayName');
        $name = is_string($name) ? trim($name) : '';
        $taken = response()->json(['error' => 'That email or username is already taken.'], 409);

        $email = strtolower(trim($request->input('email')));
        $username = strtolower(trim((string) $request->input('username')));
        if (User::where('email', $email)->exists()
            || ($username !== '' && User::where('username', $username)->exists())) {
            return $taken;
        }

        try {
            $user = DB::transaction(function () use ($request, $name) {
                $created = User::create([
                    'email' => $request->input('email'),
                    'username' => $request->input('username'),
                    'password' => $request->input('password'),
                    ...($name !== '' ? ['display_name' => $name] : []),
                ]);
                UserSettings::create(['user_id' => $created->id]);

                return $created;
            });
        } catch (UniqueConstraintViolationException) {
            return $taken; // lost a race with another registration
        }

        Log::info("User registered: id={$user->id}");

        return response()->json(['token' => $this->token($user), 'user' => $user->toPublic()], 201);
    }

    // Input is checked beforehand by LoginRequest.
    public function login(LoginRequest $request): JsonResponse
    {
        $identifier = $request->input('identifier');
        $user = User::where('email', $identifier)->orWhere('username', $identifier)->first();

        if (! $user || ! Hash::check($request->input('password'), $user->password)) {
            Log::warning("Failed login attempt from {$request->ip()}");

            return response()->json(['error' => 'Incorrect email, username or password.'], 401);
        }

        Log::info("User logged in: id={$user->id}");

        return response()->json(['token' => $this->token($user), 'user' => $user->toPublic()]);
    }

    private function token(User $user): string
    {
        return $user->createToken('mobile')->plainTextToken;
    }
}
