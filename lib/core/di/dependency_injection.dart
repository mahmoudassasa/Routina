import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routina/core/services/google_sign_in_service.dart';
import 'package:routina/core/services/habits_cache_service.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

import 'package:routina/features/login_screen/data/repos/login_repo.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/delete_account_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepo(getIt<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<GoogleSignInService>(() => GoogleSignInService());
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<LoginRepo>(), getIt<GoogleSignInService>()),
  );
  getIt.registerFactory(() => DeleteAccountCubit());

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerLazySingleton<HabitsCacheService>(
    () => HabitsCacheService(getIt<SharedPreferences>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(cacheService: getIt<HabitsCacheService>()),
  );
}