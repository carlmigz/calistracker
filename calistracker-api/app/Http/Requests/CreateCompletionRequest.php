<?php

namespace App\Http\Requests;

use Carbon\Carbon;
use Illuminate\Validation\Validator;
use Throwable;

class CreateCompletionRequest extends ApiRequest
{
    public function rules(): array
    {
        return [
            'exerciseId' => ['required', 'string'],
            'completedAt' => ['nullable'],
        ];
    }

    public function after(): array
    {
        return [
            function (Validator $validator) {
                if ($this->completedAt() === false) {
                    $validator->errors()->add('completedAt', 'The date you entered isn\'t valid.');
                }
            },
        ];
    }

    public function messages(): array
    {
        return [
            'exerciseId.required' => 'Please choose an exercise.',
            'exerciseId.string' => 'Please choose an exercise.',
        ];
    }

    /**
     * The parsed completion time: null means "now", false means the value isn't a valid date.
     * Accepts an ISO string or epoch milliseconds.
     */
    public function completedAt(): Carbon|false|null
    {
        $value = $this->input('completedAt');
        if ($value === null) {
            return null;
        }

        try {
            if (is_int($value) || is_float($value)) {
                return Carbon::createFromTimestampMsUTC((int) $value);
            }
            if (is_string($value) && trim($value) !== '') {
                return Carbon::parse($value)->utc();
            }
        } catch (Throwable) {
            // fall through
        }

        return false;
    }
}
