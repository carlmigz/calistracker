<?php

namespace App\Http\Controllers;

use App\Http\Requests\UpdateSettingsRequest;
use App\Models\UserSettings;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        return response()->json($this->load($request)->toPublic());
    }

    // Partial update: only the fields that were sent change. Input is checked by UpdateSettingsRequest.
    public function update(UpdateSettingsRequest $request): JsonResponse
    {
        $settings = $this->load($request);

        $changes = [];
        foreach (UserSettings::EDITABLE as $field => $column) {
            if ($request->has($field)) {
                $changes[$column] = $request->input($field);
            }
        }
        $settings->update($changes);

        return response()->json($settings->fresh()->toPublic());
    }

    private function load(Request $request): UserSettings
    {
        return UserSettings::firstOrCreate(['user_id' => $request->user()->id])->fresh();
    }
}
