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
  static const homeYourLevel = 'Your level';
  static const homeQuickActions = 'Quick actions';
  static const homeWelcomeTitle = 'Welcome to CalisTracker!';
  static const homeWelcomeBody =
      'Finish your first exercise to start your streak and fill in your stats.';
  static const homeStreak = 'Day streak';
  static String homeBestStreak(int days) => 'Best: $days';
  static const homeDailyGoal = 'Daily goal';
  static String homeDailyGoalCount(int done, int goal) => '$done / $goal done';
  static const homeThisWeek = 'This week';
  static String homeWeekDays(int active, int goal) =>
      '$active / $goal days';
  static String homeLevel(String name) => 'Level · $name';
  static String homeToNextLevel(int remaining, String next) =>
      '$remaining more to $next';
  static const homeMaxLevel = 'Top level reached';
  static String homeAchievements(int unlocked, int total) =>
      '$unlocked / $total achievements';
  static const homeSessions = 'Sessions';
  static const homeExercisesDone = 'Exercises';
  static const homeActiveDays = 'Active days';
  static const homeQuickTimer = 'Timer';
  static const homeQuickWorkouts = 'Workouts';
  static const homeQuickProgress = 'Progress';
  static const homeRecommended = 'Recommended for you';
  static const homeTipOfTheDay = 'Tip of the day';
  static const homeRecentActivity = 'Recent activity';
  static const homeToday = 'Today';
  static const homeYesterday = 'Yesterday';
  static String homeDaysAgo(int days) => '$days days ago';

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
  static String exerciseSetOf(int current, int total) =>
      'Set $current of $total';
  static String exerciseRepsGoal(int? reps) => '$reps reps';
  static String exerciseHoldGoal(int? seconds) => '${seconds}s hold';
  static const exerciseRest = 'Rest';
  static const exerciseResting = 'Resting…';
  static const exerciseSkipRest = 'Skip rest';
  static const exerciseRestHint = 'Shake it out and breathe';
  static const exerciseUndoSet = 'Undo last set';
  static const exerciseAllSetsDone = 'All sets done';
  static const exerciseAllSetsHint = 'Great work. Mark it as done to save it.';
  static const exerciseHoldGo = 'Hold';
  static const exerciseCompleteTitle = 'Exercise complete!';
  static String exerciseTime(String time) => 'Time: $time';
  static String exerciseNext(String name) => 'Next: $name';
  static const exerciseProgramDone = 'You finished this whole progression!';
  static const exerciseDone = 'Done';
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
  static const profileEditName = 'Edit profile';
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
  static const profileEditTitle = 'Edit profile';
  static const profileDisplayName = 'Display name';
  static const profileAvatar = 'Avatar';
  static const profileGroupProgress = 'Progress';
  static const profileStatsRecords = 'Stats & records';
  static String profileStatsSubtitle(int exercises, int bestStreak) =>
      '$exercises exercises · best streak $bestStreak';
  static const profileHeatmapSubtitle = 'Your last 12 weeks';
  static String profileRoadmapSubtitle(String level) => 'You are $level';
  static String profileProgramsSubtitle(int done, int total) =>
      '$done of $total exercises done';
  static String profileBadgesSubtitle(int unlocked, int total) =>
      '$unlocked of $total unlocked';
  static String profileGoalsSubtitle(int daily, int weekly) =>
      'Daily $daily · Weekly $weekly days';
  static const profileAppearance = 'Appearance';
  static const profileTimerFeedback = 'Timer & feedback';
  static const profileTimerFeedbackSubtitle = 'Vibration, sound, default rest';
  static const profileGoals = 'Goals';
  static const profileDailyGoal = 'Daily goal';
  static String profileDailyGoalValue(int n) =>
      n == 1 ? '1 exercise' : '$n exercises';
  static const profileDailyGoalHint = 'Shown as the ring on your home page';
  static const profileDailyLower = 'Lower daily goal';
  static const profileDailyRaise = 'Raise daily goal';
  static const profileAvatarColor = 'Avatar color';
  static String profileTrainingSince(String date) => 'Training since $date';
  static const profileRecords = 'Personal records';
  static const profileRecordBestDay = 'Best day';
  static const profileRecordSessions = 'Total sessions';
  static const profileRecordActiveDays = 'Active days';
  static const profileRecordLongest = 'Longest streak';
  static const profileHeatmap = 'Activity';
  static const profileHeatmapLast = 'Last 12 weeks';
  static const profileHeatmapLess = 'Less';
  static const profileHeatmapMore = 'More';
  static const profileRoadmap = 'Level roadmap';
  static String profileRoadmapAt(int n) => n == 0 ? 'Start' : '$n exercises';
  static const profileProgramProgress = 'Programs';
  static const profileResetProgram = 'Reset program';
  static String profileResetProgramTitle(String name) => 'Reset $name?';
  static const profileResetProgramMessage =
      'This clears your progress in this program only. Other programs are kept.';
  static const settingsHaptics = 'Vibration';
  static const settingsHapticsHint = 'Buzz when a timer phase ends';
  static const settingsSound = 'Sound';
  static const settingsSoundHint = 'Play a tone when a timer phase ends';
  static const settingsDefaultRest = 'Default rest time';
  static const settingsExport = 'Copy progress summary';
  static const settingsExportDone = 'Progress summary copied';
  static const settingsGroupPreferences = 'Preferences';
  static const settingsGroupData = 'Data';
  static const settingsResetProgressTitle ='Reset progress?';
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
