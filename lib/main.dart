import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/services/notifcation_services/app_notification.dart';
import 'package:inspect_connect/core/di/services/notifcation_services/firebase_background.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart';
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/environment_config.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/presentation/auth_user_provider.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/notification_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/session_manager.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/inspector_flow/providers/inspector_main_provider.dart';
import 'package:provider/provider.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final appRouter = AppRouter(navigatorKey: rootNavigatorKey);

Future<void> initializeFirebaseMessaging() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.init(requestPermission: false);
  FirebaseMessaging.onMessage.listen((message) {
    log('📩 [FCM] Foreground message received');
    log('📩 [FCM] Data: ${message.data}');
    log('📩 [FCM] Notification: ${message.notification?.title}');
    NotificationService.show(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final redirectUrl =
        message.data['redirectUrl'] ?? message.data['click_action'];
    if (redirectUrl != null) {
      NotificationService.handleRedirect(redirectUrl);
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = stripePublishableKey;

  await Stripe.instance.applySettings();

  await initAppComponentLocator();

  setupLocator();

  final AppFlavorsHelper configService = locator<AppFlavorsHelper>();

  final ProductFlavor? productFlavor = EnvironmentConfig.buildVariant
      .toProductFlavor();

  configService.configure(productFlavor: productFlavor);

  log('buildVariant = ${EnvironmentConfig.buildVariant}');
  log('Base URL = ${configService.baseUrl}');

  await dotenv.load(fileName: ".env");

  SessionManager().navigatorKey = rootNavigatorKey;

  await initializeFirebaseMessaging();
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Color themeColor = Color(0xFF002A86);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<UserProvider>()),
        ChangeNotifierProvider.value(value: locator<BookingProvider>()),
        ChangeNotifierProvider.value(value: locator<NotificationProvider>()),
        ChangeNotifierProvider.value(value: locator<AuthFlowProvider>()),
        ChangeNotifierProvider.value(value: locator<WalletProvider>()),
        ChangeNotifierProvider.value(
          value: locator<InspectorViewModelProvider>(),
        ),

        ChangeNotifierProvider.value(value: locator<ClientViewModelProvider>()),
        ChangeNotifierProvider.value(
          value: locator<InspectorDashboardProvider>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: themeColor,
          scaffoldBackgroundColor: Colors.white,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: themeColor,
            secondary: themeColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: themeColor,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
