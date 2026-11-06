<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Completion extends Model
{
    protected $fillable = ['user_id', 'exercise_id', 'completed_at'];

    protected function casts(): array
    {
        return ['completed_at' => 'datetime'];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function exercise(): BelongsTo
    {
        return $this->belongsTo(Exercise::class);
    }

    public function toPublic(): array
    {
        return [
            'id' => $this->id,
            'exerciseId' => $this->exercise_id,
            // UTC ISO-8601 with milliseconds, e.g. 2026-11-06T12:00:00.000Z
            'completedAt' => $this->completed_at->copy()->utc()->format('Y-m-d\TH:i:s.v\Z'),
        ];
    }
}
