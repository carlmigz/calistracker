<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Program extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    protected $guarded = [];

    public function exercises(): HasMany
    {
        return $this->hasMany(Exercise::class)->orderBy('position');
    }

    /** Same shape as assets/data/programs.json, so the app can swap its data source. */
    public function toPublic(): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'description' => $this->description,
            'exercises' => $this->exercises->map->toPublic()->all(),
        ];
    }
}
