<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('programs', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('name');
            $table->text('description')->default('');
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });

        Schema::create('exercises', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('program_id');
            $table->foreign('program_id')->references('id')->on('programs')->cascadeOnDelete();
            // Unlock order inside the program.
            $table->integer('position');
            $table->string('name');
            $table->text('description')->default('');
            // Lists of text (a Postgres text[] before); stored as JSON arrays.
            $table->jsonb('muscles')->default('[]');
            $table->jsonb('steps')->default('[]');
            $table->integer('sets');
            // Rep-based exercises set reps; timed holds set hold_seconds.
            $table->integer('reps')->nullable();
            $table->integer('hold_seconds')->nullable();
            $table->string('pose_asset')->nullable();
            $table->timestamps();

            $table->unique(['program_id', 'position']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('exercises');
        Schema::dropIfExists('programs');
    }
};
