import 'package:flutter/material.dart';

/// Icon for each program category; unknown ids get a generic dumbbell.
IconData programIcon(String programId) {
  switch (programId) {
    case 'push':
      return Icons.fitness_center;
    case 'pull':
      return Icons.vertical_align_top;
    case 'legs':
      return Icons.directions_run;
    case 'core':
      return Icons.accessibility_new;
    case 'dips':
      return Icons.swap_vert;
    case 'handstand':
      return Icons.pan_tool_alt;
    default:
      return Icons.sports_gymnastics;
  }
}
