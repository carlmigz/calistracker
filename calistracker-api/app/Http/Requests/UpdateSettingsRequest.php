<?php

namespace App\Http\Requests;

use App\Models\UserSettings;
use Illuminate\Validation\Validator;

/** Partial update: send only the settings that changed. Unknown fields are rejected. */
class UpdateSettingsRequest extends ApiRequest
{
    public function rules(): array
    {
        return [
            'themeMode' => ['sometimes', 'string', 'in:system,light,dark'],
            'weeklyGoal' => ['sometimes', 'integer', 'min:1', 'max:7'],
            'dailyGoal' => ['sometimes', 'integer', 'min:1'],
            'avatarColorIndex' => ['sometimes', 'integer', 'min:0'],
            'avatarAsset' => ['sometimes', 'string', 'max:255'],
            'hapticsEnabled' => ['sometimes', 'boolean'],
            'soundEnabled' => ['sometimes', 'boolean'],
            'defaultRestSeconds' => ['sometimes', 'integer', 'min:0'],
            'onboardingSeen' => ['sometimes', 'boolean'],
        ];
    }

    public function after(): array
    {
        return [
            function (Validator $validator) {
                $unknown = array_diff(array_keys($this->json()->all()), array_keys(UserSettings::EDITABLE));
                if ($unknown) {
                    $validator->errors()->add('settings', 'One of those settings can\'t be changed.');
                }
            },
        ];
    }

    public function messages(): array
    {
        $theme = 'Please choose Light, Dark or System.';
        $weekly = 'Your weekly goal must be between 1 and 7 days.';
        $daily = 'Your daily goal must be at least 1 exercise.';
        $avatar = 'Please choose a valid avatar color.';
        $rest = 'Rest time must be 0 seconds or more.';
        $toggle = 'That setting must be on or off.';
        $asset = 'Please choose a valid avatar.';

        return [
            'themeMode.string' => $theme, 'themeMode.in' => $theme,
            'weeklyGoal.integer' => $weekly, 'weeklyGoal.min' => $weekly, 'weeklyGoal.max' => $weekly,
            'dailyGoal.integer' => $daily, 'dailyGoal.min' => $daily,
            'avatarColorIndex.integer' => $avatar, 'avatarColorIndex.min' => $avatar,
            'avatarAsset.string' => $asset, 'avatarAsset.max' => $asset,
            'hapticsEnabled.boolean' => $toggle,
            'soundEnabled.boolean' => $toggle,
            'defaultRestSeconds.integer' => $rest, 'defaultRestSeconds.min' => $rest,
            'onboardingSeen.boolean' => $toggle,
        ];
    }
}
