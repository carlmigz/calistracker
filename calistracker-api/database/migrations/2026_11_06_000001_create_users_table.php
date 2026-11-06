<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('email')->unique();
            $table->string('username', 30)->nullable()->unique();
            $table->string('password');
            $table->string('display_name')->default('Athlete');
            $table->timestamps();
        });

        Schema::create('user_settings', function (Blueprint $table) {
            $table->foreignId('user_id')->primary()->constrained()->cascadeOnDelete();
            $table->string('theme_mode')->default('system');
            $table->integer('weekly_goal')->default(3);
            $table->integer('daily_goal')->default(3);
            $table->integer('avatar_color_index')->default(0);
            $table->string('avatar_asset')->default('');
            $table->boolean('haptics_enabled')->default(true);
            $table->boolean('sound_enabled')->default(false);
            $table->integer('default_rest_seconds')->default(60);
            $table->boolean('onboarding_seen')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_settings');
        Schema::dropIfExists('users');
    }
};
