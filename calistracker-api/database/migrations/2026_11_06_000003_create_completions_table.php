<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('completions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('exercise_id');
            $table->foreign('exercise_id')->references('id')->on('exercises')->cascadeOnDelete();
            $table->timestampTz('completed_at')->useCurrent();
            $table->timestamps();

            $table->index(['user_id', 'completed_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('completions');
    }
};
