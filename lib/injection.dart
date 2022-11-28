import 'package:get_it/get_it.dart';
import 'package:maps_clean_app/application/app_life_cycle/application_life_cycle_cubit.dart';
import 'package:maps_clean_app/infrastructure/permission/permissionServicesImpl.dart';

import 'application/permission/permission_cubit.dart';
import 'domain/permetions/i_permention_service.dart';

final GetIt getIt = GetIt.instance;

initialize() {
  getIt.registerLazySingleton<IPermissionServices>(
      () => PermissionServicesImpl());

  getIt.registerLazySingleton<ApplicationLifeCycleCubit>(
      () => ApplicationLifeCycleCubit());

  getIt.registerLazySingleton<PermissionCubit>(
      () => PermissionCubit(getIt(), getIt()));
}
