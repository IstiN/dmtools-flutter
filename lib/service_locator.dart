import 'package:dmtools/core/config/app_config.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
import 'package:dmtools/network/services/dm_tools_api_service_impl.dart';
import 'package:dmtools/network/services/dm_tools_api_service_mock.dart';
import 'package:dmtools/providers/auth_provider.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';
import 'package:get_it/get_it.dart';

abstract final class ServiceLocator {
  static void init() {
    GetIt.I.registerLazySingleton(ThemeProvider.new);
    GetIt.I.registerLazySingleton(() => AuthProvider(
          apiService: get(),
        ));

    GetIt.I.registerLazySingleton<DmToolsApiService>(() => AppConfig.enableMockData
        ? DmToolsApiServiceMock()
        : DmToolsApiServiceImpl(
            baseUrl: AppConfig.baseUrl,
            enableLogging: AppConfig.enableLogging,
          ));
  }

  static T get<T extends Object>() => GetIt.I.get<T>();
}
