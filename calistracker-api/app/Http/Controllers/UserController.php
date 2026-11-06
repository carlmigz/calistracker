<?php

namespace App\Http\Controllers;

use App\Http\Requests\UpdateMeRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        return response()->json($request->user()->toPublic());
    }

    // Input is checked beforehand by UpdateMeRequest.
    public function update(UpdateMeRequest $request): JsonResponse
    {
        $user = $request->user();
        $user->update(['display_name' => trim($request->input('displayName'))]);

        return response()->json($user->toPublic());
    }
}
