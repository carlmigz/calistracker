import 'package:equatable/equatable.dart';

enum Gender { male, female, nonBinary, preferNotToSay }

enum FitnessGoal {
  buildStrength,
  loseWeight,
  buildMuscle,
  improveEndurance,
  learnSkills,
  stayActive,
}

enum ExperienceLevel { newbie, some, experienced }

enum HeightUnit { cm, inch }

enum WeightUnit { kg, lb }

/// Body details and goals collected at sign up. Height and weight are always
/// stored in metric; the units are only the user's display preference.
class AccountProfile extends Equatable {
  const AccountProfile({
    required this.email,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.heightUnit,
    required this.weightUnit,
    required this.goals,
    required this.experience,
    required this.daysPerWeek,
  });

  static const cmPerInch = 2.54;
  static const lbPerKg = 2.2046226218;

  final String email;
  final Gender gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final HeightUnit heightUnit;
  final WeightUnit weightUnit;
  final Set<FitnessGoal> goals;
  final ExperienceLevel experience;
  final int daysPerWeek;

  @override
  List<Object?> get props => [
    email,
    gender,
    age,
    heightCm,
    weightKg,
    heightUnit,
    weightUnit,
    goals,
    experience,
    daysPerWeek,
  ];
}
