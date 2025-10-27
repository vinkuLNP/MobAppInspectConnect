// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:inspect_connect/core/di/app_component/app_module.dart' as _i110;
import 'package:inspect_connect/core/utils/helpers/app_configurations_helper/app_configurations_helper.dart'
    as _i238;
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart'
    as _i807;
import 'package:inspect_connect/core/utils/helpers/connectivity_helper/connectivity_helper/connectivity_checker_helper.dart'
    as _i320;
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_context.dart'
    as _i1009;
import 'package:inspect_connect/core/utils/helpers/responsive_ui_helper/responsive_config.dart'
    as _i251;
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/app_local_database.dart'
    as _i168;
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart'
    as _i19;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i168.AppLocalDatabase>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.factory<_i320.ConnectivityCheckerHelper>(
      () => _i320.ConnectivityCheckerHelper(),
    );
    gh.singleton<_i251.ResponsiveUiConfig>(() => _i251.ResponsiveUiConfig());
    gh.singleton<_i807.AppFlavorsHelper>(() => _i807.AppFlavorsHelper());
    gh.singleton<_i238.AppConfigurations>(() => _i238.AppConfigurations());
    gh.factory<_i1009.HttpRequestContext>(
      () => _i1009.HttpRequestContext(gh<_i320.ConnectivityCheckerHelper>()),
    );
    gh.factory<_i19.AuthLocalDataSource>(
      () => _i19.AuthLocalDataSource(gh<_i168.AppLocalDatabase>()),
    );
    return this;
  }
}

class _$AppModule extends _i110.AppModule {}
