<?php

namespace App\Http\Requests;

class LoginRequest extends ApiRequest
{
    /** `identifier` is an email or username; `email` / `username` are accepted as aliases. */
    protected function prepareForValidation(): void
    {
        $identifier = $this->input('identifier') ?? $this->input('email') ?? $this->input('username');

        $this->merge([
            'identifier' => is_scalar($identifier) ? strtolower(trim((string) $identifier)) : null,
        ]);
    }

    public function rules(): array
    {
        return [
            'identifier' => ['required', 'string'],
            'password' => ['required', 'string'],
        ];
    }

    public function messages(): array
    {
        return [
            'identifier.required' => 'Please enter your email or username.',
            'identifier.string' => 'Please enter your email or username.',
            'password.required' => 'Please enter your password.',
            'password.string' => 'Please enter your password.',
        ];
    }
}
