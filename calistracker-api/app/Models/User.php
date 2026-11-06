<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens;

    protected $fillable = ['email', 'username', 'password', 'display_name'];

    protected $hidden = ['password'];

    protected function casts(): array
    {
        return ['password' => 'hashed'];
    }

    protected function email(): Attribute
    {
        return Attribute::set(fn ($value) => strtolower(trim((string) $value)));
    }

    protected function username(): Attribute
    {
        return Attribute::set(function ($value) {
            $v = strtolower(trim((string) $value));

            return $v === '' ? null : $v;
        });
    }

    public function settings(): HasOne
    {
        return $this->hasOne(UserSettings::class);
    }

    public function completions(): HasMany
    {
        return $this->hasMany(Completion::class);
    }

    public function toPublic(): array
    {
        return [
            'id' => $this->id,
            'email' => $this->email,
            'username' => $this->username,
            'displayName' => $this->display_name,
        ];
    }
}
