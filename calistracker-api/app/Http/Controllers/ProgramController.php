<?php

namespace App\Http\Controllers;

use App\Models\Program;
use Illuminate\Http\JsonResponse;

class ProgramController extends Controller
{
    public function index(): JsonResponse
    {
        $programs = Program::with('exercises')->orderBy('sort_order')->orderBy('id')->get();

        return response()->json(['programs' => $programs->map->toPublic()->all()]);
    }

    public function show(string $id): JsonResponse
    {
        $program = Program::with('exercises')->find($id);
        if (! $program) {
            return response()->json(['error' => 'We couldn\'t find that program.'], 404);
        }

        return response()->json($program->toPublic());
    }
}
