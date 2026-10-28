import 'package:calistracker/core/session/app_session.dart';
import 'package:calistracker/features/profile/data/repositories/settings_repository_impl.dart';
import 'package:calistracker/features/profile/domain/repositories/settings_repository.dart';
import 'package:calistracker/features/progress/data/datasources/progress_local_datasource.dart';
import 'package:calistracker/features/progress/data/repositories/progress_repository_impl.dart';
import 'package:calistracker/features/progress/domain/repositories/progress_repository.dart';
import 'package:calistracker/features/programs/data/datasources/programs_local_datasource.dart';
import 'package:calistracker/features/programs/data/repositories/programs_repository_impl.dart';
import 'package:calistracker/features/programs/domain/repositories/programs_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Builds the app-wide objects once; there is no DI container.
class AppDependencies {
  AppDependencies(SharedPreferences prefs)
    : session = AppSession(prefs),
      programsRepository = const ProgramsRepositoryImpl(
        ProgramsLocalDataSourceImpl(),
      ),
      progressRepository = ProgressRepositoryImpl(
        ProgressLocalDataSourceImpl(prefs),
      ),
      settingsRepository = SettingsRepositoryImpl(prefs);

  final AppSession session;
  final ProgramsRepository programsRepository;
  final ProgressRepository progressRepository;
  final SettingsRepository settingsRepository;

  void dispose() => session.dispose();
}
