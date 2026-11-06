import 'package:calistracker/features/auth/domain/entities/account_profile.dart';
import 'package:flutter/material.dart';

/// Labels and icons for the sign-up choices (kept out of the domain layer).
class SignUpOption {
  const SignUpOption(this.label, this.icon, [this.hint]);

  final String label;
  final IconData icon;
  final String? hint;
}

abstract final class SignUpOptions {
  static const genders = {
    Gender.male: SignUpOption('Male', Icons.male),
    Gender.female: SignUpOption('Female', Icons.female),
    Gender.nonBinary: SignUpOption('Non-binary', Icons.transgender),
    Gender.preferNotToSay: SignUpOption(
      'Prefer not to say',
      Icons.person_outline,
    ),
  };

  static const goals = {
    FitnessGoal.buildStrength: SignUpOption(
      'Build strength',
      Icons.fitness_center,
    ),
    FitnessGoal.loseWeight: SignUpOption('Lose weight', Icons.monitor_weight),
    FitnessGoal.buildMuscle: SignUpOption(
      'Build muscle',
      Icons.sports_gymnastics,
    ),
    FitnessGoal.improveEndurance: SignUpOption(
      'Improve endurance',
      Icons.directions_run,
    ),
    FitnessGoal.learnSkills: SignUpOption(
      'Learn skills',
      Icons.emoji_events_outlined,
    ),
    FitnessGoal.stayActive: SignUpOption('Stay active', Icons.favorite_border),
  };

  static const experience = {
    ExperienceLevel.newbie: SignUpOption(
      'Brand new',
      Icons.eco_outlined,
      'I have never trained',
    ),
    ExperienceLevel.some: SignUpOption(
      'Some experience',
      Icons.trending_up,
      'I can do a few push-ups',
    ),
    ExperienceLevel.experienced: SignUpOption(
      'Experienced',
      Icons.bolt,
      'I train regularly',
    ),
  };
}
