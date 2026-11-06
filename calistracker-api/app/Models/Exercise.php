<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Exercise extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    protected $guarded = [];

    protected function casts(): array
    {
        return [
            'muscles' => 'array',
            'steps' => 'array',
            'position' => 'integer',
            'sets' => 'integer',
            'reps' => 'integer',
            'hold_seconds' => 'integer',
        ];
    }

    public function program(): BelongsTo
    {
        return $this->belongsTo(Program::class);
    }

    public function completions(): HasMany
    {
        return $this->hasMany(Completion::class);
    }

    public function toPublic(): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'description' => $this->description,
            'muscles' => $this->muscles ?? [],
            'steps' => $this->steps ?? [],
            'sets' => $this->sets,
            // Rep-based exercises set reps; timed holds set holdSeconds; poseAsset is optional.
            ...($this->reps !== null ? ['reps' => $this->reps] : []),
            ...($this->hold_seconds !== null ? ['holdSeconds' => $this->hold_seconds] : []),
            ...($this->pose_asset !== null ? ['poseAsset' => $this->pose_asset] : []),
        ];
    }
}
