// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:inspect_connect/core/di/app_component/app_module.dart'
    as _i465;
import 'package:inspect_connect/core/utils/helpers/app_configurations_helper/app_configurations_helper.dart'
    as _i367;
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart'
    as _i300;
import 'package:inspect_connect/core/utils/helpers/connectivity_helper/connectivity_helper/connectivity_checker_helper.dart'
    as _i33;
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_context.dart'
    as _i577;
import 'package:inspect_connect/core/utils/helpers/responsive_ui_helper/responsive_config.dart'
    as _i489;
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/app_local_database.dart'
    as _i61;
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart'
    as _i947;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i61.AppLocalDatabase>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.factory<_i33.ConnectivityCheckerHelper>(
      () => _i33.ConnectivityCheckerHelper(),
    );
    gh.singleton<_i489.ResponsiveUiConfig>(() => _i489.ResponsiveUiConfig());
    gh.singleton<_i300.AppFlavorsHelper>(() => _i300.AppFlavorsHelper());
    gh.singleton<_i367.AppConfigurations>(() => _i367.AppConfigurations());
    gh.factory<_i577.HttpRequestContext>(
      () => _i577.HttpRequestContext(gh<_i33.ConnectivityCheckerHelper>()),
    );
    gh.factory<_i947.AuthLocalDataSource>(
      () => _i947.AuthLocalDataSource(gh<_i61.AppLocalDatabase>()),
    );
    return this;
  }
}

class _$AppModule extends _i465.AppModule {}
