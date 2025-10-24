import 'package:inspect_connect/core/di/app_component/app_component.config.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/remote_datasources/auth_remote_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/repositories/auth_repository_impl.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/otp_verification_usecases.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/resend_otp_usecases.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/sign_in_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/sign_up_usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';


final GetIt locator = GetIt.I;

@InjectableInit(
  preferRelativeImports: false,
)
Future<void> initAppComponentLocator() async => locator.init();

void setupLocator() {
  locator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(locator()));
  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(locator()));
  locator.registerLazySingleton(() => SignInUseCase(locator()));
  locator.registerLazySingleton(() => SignUpUseCase(locator()));
  locator.registerLazySingleton(() => OtpVerificarionUseCase(locator()));
  locator.registerLazySingleton(() => ResendOtpUseCase(locator()));
}



