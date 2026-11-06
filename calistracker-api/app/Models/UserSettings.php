<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserSettings extends Model
{
    protected $table = 'user_settings';

    protected $primaryKey = 'user_id';

    public $incrementing = false;

    protected $guarded = [];

    /** API field name => column. Only these fields can be changed by a client. */
    public const EDITABLE = [
        'themeMode' => 'theme_mode',
        'weeklyGoal' => 'weekly_goal',
        'dailyGoal' => 'daily_goal',
        'avatarColorIndex' => 'avatar_color_index',
        'avatarAsset' => 'avatar_asset',
        'hapticsEnabled' => 'haptics_enabled',
        'soundEnabled' => 'sound_enabled',
        'defaultRestSeconds' => 'default_rest_seconds',
        'onboardingSeen' => 'onboarding_seen',
    ];

    /** Defaults, mirrored from the migration so a freshly created row is complete in memory. */
    protected $attributes = [
        'theme_mode' => 'system',
        'weekly_goal' => 3,
        'daily_goal' => 3,
        'avatar_color_index' => 0,
        'avatar_asset' => '',
        'haptics_enabled' => true,
        'sound_enabled' => false,
        'default_rest_seconds' => 60,
        'onboarding_seen' => false,
    ];

    protected function casts(): array
    {
        return [
            'weekly_goal' => 'integer',
            'daily_goal' => 'integer',
            'avatar_color_index' => 'integer',
            'default_rest_seconds' => 'integer',
            'haptics_enabled' => 'boolean',
            'sound_enabled' => 'boolean',
            'onboarding_seen' => 'boolean',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function toPublic(): array
    {
        $out = [];
        foreach (self::EDITABLE as $field => $column) {
            $out[$field] = $this->{$column};
        }

        return $out;
    }
}
