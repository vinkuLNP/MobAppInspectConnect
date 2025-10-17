// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clean_architecture/core/utils/helpers/app_configurations_helper/app_configurations_helper.dart'
    as _i367;
import 'package:clean_architecture/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart'
    as _i300;
import 'package:clean_architecture/core/utils/helpers/connectivity_helper/connectivity_helper/connectivity_checker_helper.dart'
    as _i33;
import 'package:clean_architecture/core/utils/helpers/http_strategy_helper/http_request_context.dart'
    as _i577;
import 'package:clean_architecture/core/utils/helpers/responsive_ui_helper/responsive_config.dart'
    as _i489;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i33.ConnectivityCheckerHelper>(
      () => _i33.ConnectivityCheckerHelper(),
    );
    gh.singleton<_i489.ResponsiveUiConfig>(() => _i489.ResponsiveUiConfig());
    gh.singleton<_i300.AppFlavorsHelper>(() => _i300.AppFlavorsHelper());
    gh.singleton<_i367.AppConfigurations>(() => _i367.AppConfigurations());
    gh.factory<_i577.HttpRequestContext>(
      () => _i577.HttpRequestContext(gh<_i33.ConnectivityCheckerHelper>()),
    );
    return this;
  }
}
