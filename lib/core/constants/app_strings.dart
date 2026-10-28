abstract final class AppStrings {
  // Common
  static const appName = 'CalisTracker';
  static const cancel = 'Cancel';
  static const save = 'Save';
  static const reset = 'Reset';
  static const rest = 'Rest';
  static const work = 'Work';
  static const dayStreak = 'Day streak';
  static const progress = 'Progress';
  static const profile = 'Profile';
  static const exercises = 'Exercises';
  static const somethingWentWrong = 'Something went wrong';

  // Navigation
  static const navHome = 'Home';
  static const navWorkouts = 'Workouts';
  static const navTimer = 'Timer';

  // Failures
  static const parseFailure = 'Could not read the training data';
  static const storageFailure = 'Could not save your progress';

  // Validators
  static const fieldRequired = 'This field is required';
  static const emailInvalid = 'Enter valid email address';
  static const passwordNoSpaces = 'Password must not contain spaces';
  static const passwordTooShort = 'Password must be at least 8 characters';
  static const confirmPasswordRequired = 'Confirm your password';
  static const passwordsDoNotMatch = 'Passwords do not match';
  static const firstNameLabel = 'First';
  static const lastNameLabel = 'Last';
  static const phoneRequired = 'Phone number is required';
  static const phoneInvalid = 'Enter a valid 10-digit phone number';
  static String nameRequired(String label) => '$label name is required';
  static String nameTooShort(String label) =>
      '$label name must be at least 2 characters';
  static String nameInvalid(String label) =>
      'Enter a valid ${label.toLowerCase()} name';

  // Onboarding
  static const onboardingTagline =
      'Your free companion for mastering bodyweight training with CALISTRACKER';
  static const onboardingContinue = 'Continue';

  // Login
  static const loginPasswordResetSoon = 'Password reset is coming soon';
  static const loginWelcomeBack = 'Welcome back';
  static const loginSubtitle = 'Sign in to continue your training';
  static const loginEmail = 'Email';
  static const loginPassword = 'Password';
  static const loginForgotPassword = 'Forgot password?';
  static const loginSignIn = 'Sign In';

  // Home
  static const homeGoodMorning = 'Good morning';
  static const homeGoodAfternoon = 'Good afternoon';
  static const homeGoodEvening = 'Good evening';
  static const homeReadyToTrain = 'Ready to train?';
  static const homeExerciseTypes = 'Exercise types';
  static const homeTryAgain = 'Try again';
  static const homeAllDone = 'All done!';
  static const homeFinishedEverything = 'You finished every exercise';
  static String homeUpNext(String programName) => 'Up next · $programName';
  static const homeYourProgress = 'Your progress';
  static String homeExercisesCompleted(int completed, int total) =>
      '$completed of $total exercises completed';

  // Workouts
  static const workoutsExercisesTab = exercises;
  static const workoutsLibraryTab = 'Library';
  static const workoutsSearchHint = 'Search exercises';
  static const workoutsNoMatch = 'No exercises match';
  static const workoutsClearSearch = 'Clear search';
  static const workoutsClearFilters = 'Clear filters';
  static const workoutsFilterAll = 'All';
  static const workoutsUpNext = 'Up next';
  static String workoutsSummary(int done, int total) =>
      '$done of $total exercises done';
  static String workoutsFinishFirst(String previous) =>
      'Finish "$previous" first';

  // Programs
  static const programNotFound = 'Program not found';
  static String programExercisesDone(int done, int total) =>
      '$done / $total exercises';

  // Exercise
  static const exerciseNotFound = 'Exercise not found';
  static const exerciseHowTo = 'How to';
  static const exerciseMarkAsDone = 'Mark as done';
  static String exerciseTarget(String target, String muscles) =>
      'Target: $target  •  $muscles';
  static String exerciseSets(int done, int total) => 'Sets: $done / $total';
  static String exerciseHolding(int secondsLeft) => 'Hold… ${secondsLeft}s';
  static String exerciseStartHold(int? seconds) => 'Start hold (${seconds}s)';
  static String exerciseCompleteSet(int? reps) => 'Complete set ($reps reps)';

  // Timer
  static const timerReady = 'Ready';
  static const timerDone = 'Done!';
  static const timerInterval = 'Interval';
  static const timerPause = 'Pause';
  static const timerStart = 'Start';
  static const timerResume = 'Resume';
  static const timerRounds = 'Rounds';
  static const timerPresetTabata = 'Tabata 20/10 × 8';
  static const timerPresetCircuit = 'Circuit 40/20 × 5';
  static String timerTotal(String time) => 'Total $time';
  static String timerRound(int round, int rounds) => 'Round $round / $rounds';
  static String timerMinutes(int minutes) => '$minutes min';
  static String timerSeconds(int seconds) => '$seconds s';

  // Progress
  static const progressSessionsDone = 'Sessions done';
  static const progressThisWeek = 'This week';
  static const progressRecentActivity = 'Recent activity';
  static const progressEmptyActivity =
      'Finish an exercise and it will show up here.';
  static const today = 'Today';
  static const yesterday = 'Yesterday';

  // Profile
  static const profileBadges = 'Badges';
  static const profileSettings = 'Settings';
  static const profileYourName = 'Your name';
  static const profileEditName = 'Edit name';
  static const profileTopLevel = 'Top level reached';
  static String profileMoreToLevel(int remaining, String? nextName) =>
      '$remaining more exercise${remaining == 1 ? '' : 's'} to $nextName';
  static String profileBadgeLocked(String description) =>
      'Locked: $description';
  static const profilePrograms = 'Programs';
  static const profileBestStreak = 'Best streak';
  static const profileWeeklyGoal = 'Weekly goal';
  static const profileGoalReached = 'Goal reached this week';
  static const profileGoalLower = 'Lower goal';
  static const profileGoalRaise = 'Raise goal';
  static String profileGoalProgress(int active, int goal) =>
      '$active of $goal active days (last 7 days)';
  static String profileGoalDays(int days) => days == 1 ? '1 day' : '$days days';
  static const settingsResetProgressTitle = 'Reset progress?';
  static const settingsResetProgressMessage =
      'This clears every completed exercise, your streak and badges. '
      'It cannot be undone.';
  static const settingsTheme = 'Theme';
  static const settingsThemeSystem = 'System';
  static const settingsThemeLight = 'Light';
  static const settingsThemeDark = 'Dark';
  static const settingsResetProgress = 'Reset progress';
  static const settingsAbout = 'About CalisTracker';
  static const settingsLegalese = 'A free beginner calisthenics companion.';
  static const settingsLogOut = 'Log out';
}
