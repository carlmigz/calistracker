<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateCompletionRequest;
use App\Models\Completion;
use App\Models\Exercise;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class CompletionController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $completions = Completion::where('user_id', $request->user()->id)
            ->orderBy('completed_at')
            ->orderBy('id')
            ->get();

        return response()->json(['completions' => $completions->map->toPublic()->all()]);
    }

    // Input is checked beforehand by CreateCompletionRequest.
    public function store(CreateCompletionRequest $request): JsonResponse
    {
        $exerciseId = $request->input('exerciseId');
        if (! Exercise::whereKey($exerciseId)->exists()) {
            return response()->json(['error' => 'We couldn\'t find that exercise.'], 404);
        }

        $completion = Completion::create([
            'user_id' => $request->user()->id,
            'exercise_id' => $exerciseId,
            'completed_at' => $request->completedAt() ?? now(),
        ]);

        return response()->json($completion->toPublic(), 201);
    }

    public function destroy(Request $request, string $id): JsonResponse|Response
    {
        $deleted = ctype_digit($id)
            ? Completion::where('id', $id)->where('user_id', $request->user()->id)->delete()
            : 0;

        if (! $deleted) {
            return response()->json(['error' => 'We couldn\'t find that workout record.'], 404);
        }

        return response()->noContent();
    }
}
