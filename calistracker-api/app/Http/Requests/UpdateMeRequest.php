<?php

namespace App\Http\Requests;

class UpdateMeRequest extends ApiRequest
{
    public function rules(): array
    {
        return [
            'displayName' => ['required', 'string', 'max:255'],
        ];
    }

    public function messages(): array
    {
        return [
            'displayName.required' => 'Please enter your name.',
            'displayName.string' => 'Please enter your name.',
            'displayName.max' => 'Please enter a shorter name.',
        ];
    }
}
