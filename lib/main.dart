import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart';
import 'package:inspect_connect/core/utils/helpers/app_flavor_helper/environment_config.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI first
  await initAppComponentLocator();
  setupLocator();
  // Then configure the flavor
  final AppFlavorsHelper configService = locator<AppFlavorsHelper>();
  final ProductFlavor? _productFlavor = EnvironmentConfig.BUILD_VARIANT
      .toProductFlavor();
  // prodEnvironmentString
  configService.configure(productFlavor: _productFlavor);
  print(' BUILD_VARIANT = ${EnvironmentConfig.BUILD_VARIANT}');
  print(' Base URL = ${configService.baseUrl}');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const Color themeColor = Color(0xff1a2c47);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: themeColor,
        scaffoldBackgroundColor: Colors.white,
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
    );

    //  return MultiProvider(
    //   providers: [
    //     // ChangeNotifierProvider<OnBoardingProvider>(
    //     //   create: (BuildContext context) => locator<OnBoardingProvider>(),
    //     // ),
    //   ],
    //   child: MaterialApp.router(
    //     routerConfig: _appRouter.config(),
    //     debugShowCheckedModeBanner: false,
    //   ),
    // );
  }
}




