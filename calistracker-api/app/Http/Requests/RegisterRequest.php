<?php

namespace App\Http\Requests;

class RegisterRequest extends ApiRequest
{
    public function rules(): array
    {
        return [
            'email' => ['required', 'string', 'max:255', 'regex:/^[^\s@]+@[^\s@]+\.[^\s@]+$/'],
            'username' => ['nullable', 'string', 'regex:/^[a-zA-Z0-9_]{3,30}$/'],
            'password' => ['required', 'string', 'min:6'],
        ];
    }

    public function messages(): array
    {
        $email = 'Please enter a valid email address.';
        $username = 'Username must be 3 to 30 characters, using only letters, numbers or underscores.';

        return [
            'email.required' => $email,
            'email.string' => $email,
            'email.max' => $email,
            'email.regex' => $email,
            'username.string' => $username,
            'username.regex' => $username,
            'password.required' => 'Your password must be at least 6 characters long.',
            'password.string' => 'Your password must be at least 6 characters long.',
            'password.min' => 'Your password must be at least 6 characters long.',
        ];
    }
}
