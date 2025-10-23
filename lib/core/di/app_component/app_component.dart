import 'package:clean_architecture/core/di/app_component/app_component.config.dart';
import 'package:clean_architecture/core/utils/helpers/connectivity_helper/connectivity_helper/connectivity_checker_helper.dart';
import 'package:clean_architecture/core/utils/helpers/http_strategy_helper/http_request_context.dart';
import 'package:clean_architecture/features/auth_flow/data/datasources/auth_remote_datasource.dart';
import 'package:clean_architecture/features/auth_flow/data/repositories/auth_repository_impl.dart';
import 'package:clean_architecture/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:clean_architecture/features/auth_flow/domain/usecases/otp_verification_usecases.dart';
import 'package:clean_architecture/features/auth_flow/domain/usecases/resend_otp_usecases.dart';
import 'package:clean_architecture/features/auth_flow/domain/usecases/sign_in_usecase.dart';
import 'package:clean_architecture/features/auth_flow/domain/usecases/sign_up_usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';


final GetIt locator = GetIt.I;

@InjectableInit(
  preferRelativeImports: false,
)
Future<void> initAppComponentLocator() async => locator.init();

void setupLocator() {
  // Common dependencies
  // locator.registerLazySingleton(() => ConnectivityCheckerHelper());
  // locator.registerLazySingleton(() => HttpRequestContext(locator()));

  // Auth-specific
  locator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(locator()));
  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(locator()));

  // Use cases — registered lazily, won’t initialize until used
  locator.registerLazySingleton(() => SignInUseCase(locator()));
  locator.registerLazySingleton(() => SignUpUseCase(locator()));
  locator.registerLazySingleton(() => OtpVerificarionUseCase(locator()));
  locator.registerLazySingleton(() => ResendOtpUseCase(locator()));


  // locator.registerLazySingleton(() => SignUpUseCase(locator()));
}
