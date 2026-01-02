import 'package:inspect_connect/core/di/app_component/app_component.config.dart';
import 'package:inspect_connect/core/di/services/app_sockets/socket_service.dart';
import 'package:inspect_connect/core/di/services/payment_services/stripe_service.dart';
import 'package:inspect_connect/core/di/services/payment_services/stripe_service_implementation.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/remote_datasources/auth_remote_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/repositories/auth_repository_impl.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/agency_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/certificate_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/change_password_usecases.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/document_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/get_user__usercase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/inspector_signup_case.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/jurisdiction_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/otp_verification_usecases.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/resend_otp_usecases.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/sign_in_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/sign_up_usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/update_profile_usecase.dart';
import 'package:inspect_connect/features/auth_flow/presentation/auth_user_provider.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/client_flow/data/datasources/remote_datasource/client_api_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/repositories/client_repository_imp.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/apply_show_up_fee.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/create_booking_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/delete_booking_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/fetch_booking_list_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_booking_Detail_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_certificate_subtype_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_user_payments_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_user_wallet_amount_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_detail_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_status.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_timer.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/session_manager.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/data/datasources/remote_datasource/inspector_api_datasource.dart';
import 'package:inspect_connect/features/inspector_flow/data/repositories/inspector_repository_imp.dart';
import 'package:inspect_connect/features/inspector_flow/domain/repositories/inspector_repository.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/get_subscription_plans_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/get_user_subscription_detail_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/payment_intent_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/providers/inspector_main_provider.dart';

final GetIt locator = GetIt.I;

@InjectableInit(preferRelativeImports: false)
Future<void> initAppComponentLocator() async => locator.init();

void setupLocator() {
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator()),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<ClientUserRepository>(
    () => ClientUserRepositoryImpl(locator()),
  );

  locator.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(locator()),
  );

  locator.registerLazySingleton<InspectorRemoteDataSource>(
    () => InspectorRemoteDataSourceImpl(locator()),
  );

  locator.registerLazySingleton<InspectorRepository>(
    () => InspectorRepositoryImpl(locator()),
  );

  locator.registerLazySingleton(() => SignInUseCase(locator()));
  locator.registerLazySingleton(() => SignUpUseCase(locator()));
  locator.registerLazySingleton(() => OtpVerificarionUseCase(locator()));
  locator.registerLazySingleton(() => ResendOtpUseCase(locator()));
  locator.registerLazySingleton(() => ChangePasswordUseCase(locator()));
  locator.registerLazySingleton(() => GetCertificateSubTypesUseCase(locator()));
  locator.registerLazySingleton(() => CreateBookingUseCase(locator()));
  locator.registerLazySingleton(() => GetBookingDetailUseCase(locator()));
  locator.registerLazySingleton(() => UpdateBookingDetailUseCase(locator()));
  locator.registerLazySingleton(() => DeleteBookingDetailUseCase(locator()));
  locator.registerLazySingleton(() => GetUserWalletAmountUseCase(locator()));
  locator.registerLazySingleton(() => GetUserPaymentsListUseCase(locator()));
  locator.registerLazySingleton(() => GetUserUseCase(locator()));
  locator.registerLazySingleton(() => UpdateProfileUseCase(locator()));
  locator.registerLazySingleton(() => GetSubscriptionPlansUseCase(locator()));
  locator.registerLazySingleton(() => GetPaymentIntentUseCase(locator()));

  locator.registerLazySingleton(
    () => GetUserSubscriptionDetailUseCase(locator()),
  );

  locator.registerLazySingleton(() => UpdateBookingStatusUseCase(locator()));
  locator.registerLazySingleton(() => UpdateBookingTimerUseCase(locator()));
  locator.registerLazySingleton(() => ShowUpFeeStatusUseCase(locator()));

  locator.registerLazySingleton(() => GetAgencyUseCase(locator()));
  locator.registerLazySingleton(() => GetCertificateTypeUseCase(locator()));
  locator.registerLazySingleton(() => InspectorSignUpUseCase(locator()));

  locator.registerLazySingleton(() => GetJurisdictionCitiesUseCase(locator()));
  locator.registerLazySingleton(
    () => GetInspectorDocumentsTypeUseCase(locator()),
  );

  locator.registerLazySingleton(() => FetchBookingsUseCase(locator()));
  locator.registerLazySingleton<SocketService>(() => SocketService());

  locator.registerLazySingleton(() => UploadImageUseCase(locator()));
  locator.registerLazySingleton<UserProvider>(() => UserProvider());
  locator.registerLazySingleton<BookingProvider>(() => BookingProvider());

  locator.registerLazySingleton<SessionManager>(() => SessionManager());

  locator.registerLazySingleton<AuthFlowProvider>(() => AuthFlowProvider());

  locator.registerLazySingleton<ClientViewModelProvider>(
    () => ClientViewModelProvider(),
  );

  locator.registerLazySingleton<InspectorDashboardProvider>(
    () => InspectorDashboardProvider(),
  );

  locator.registerLazySingleton<StripeService>(() => StripeServiceImpl());
}
