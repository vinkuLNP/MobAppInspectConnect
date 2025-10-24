import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_logo_bar.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: formKey,
              child: Consumer<ClientViewModelProvider>(
                builder: (_, vm, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    appCommonLogoBar(height: rc.screenHeight * 0.2),
                    Align(
                      alignment: Alignment.center,
                      child: textWidget(
                        text: vm.otpPurpose == OtpPurpose.forgotPassword
                            ? 'Reset Password'
                            : 'Set Your Password',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(
                      height: (rc.screenHeight * 0.05).clamp(24.0, 40.0),
                    ),

                    AppPasswordField(
                      label: 'New Password',
                      controller: vm.passwordCtrlSignUp,
                      obscure: vm.obscurePassword,
                      onToggle: vm.toggleObscurePassword,
                      validator: vm.validatePassword,
                      onChanged: (_) {
                        if (vm.autoValidate) formKey.currentState?.validate();
                      },
                    ),
                    const SizedBox(height: 20),

                    AppPasswordField(
                      label: 'Confirm New Password',
                      controller: vm.confirmPasswordCtrl,
                      obscure: vm.obscureConfirm,
                      onToggle: vm.toggleObscureConfirm,
                      validator: vm.validateConfirmPassword,
                      onChanged: (_) {
                        if (vm.autoValidate) formKey.currentState?.validate();
                      },
                    ),

                    SizedBox(
                      height: (rc.screenHeight * 0.08).clamp(40.0, 80.0),
                    ),

                    SizedBox(
                      height: 54,
                      child: AppButton(
                        buttonBackgroundColor: AppColors.themeColor,
                        onTap: () async{
                          print('tapped');
                          final isValid =
                              formKey.currentState?.validate() ?? false;
                          print('tapped 2');
                              
                          if (!isValid) {
                            vm.enableAutoValidate();
                          print('tapped 3');

                            return;
                          }
                          print('tapped 4');

                          // vm.isResetting
                          //     ? null
                          //     :
                            await   
                            vm.resetPassword(
                                  formKey: formKey,
                                  context: context,
                                );
                        },
                        text: vm.isResetting
                            ? 'Resetting...'
                            : vm.otpPurpose == OtpPurpose.forgotPassword
                            ? 'Reset Password'
                            : 'Set Your Password',
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWidget(text: "Already have an account?"),
                        GestureDetector(
                          onTap: () {
                            context.pushRoute(const ClientSignInRoute());
                          },
                          child: textWidget(
                            text: 'Sign In',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            colour: AppColors.themeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}






// 🧩 Root Cause

// One of these is true:

// AuthRemoteDataSourceImpl was registered without specifying that it implements AuthRemoteDataSource.

// The injection annotation is missing or incorrect (@injectable / @LazySingleton(as: AuthRemoteDataSource)).

// app_component.config.dart wasn’t rebuilt after adding new annotations.

// ✅ Correct Implementation
// 1️⃣ Abstract & Implementation
// auth_remote_data_source.dart
// abstract class AuthRemoteDataSource {
//   Future<void> signUp();
//   Future<void> verifyOtp();
// }

// auth_remote_data_source_impl.dart
// import 'package:injectable/injectable.dart';
// import 'auth_remote_data_source.dart';

// @LazySingleton(as: AuthRemoteDataSource)
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   @override
//   Future<void> signUp() async {
//     // Implementation
//   }

//   @override
//   Future<void> verifyOtp() async {
//     // Implementation
//   }
// }

// 2️⃣ Repository Depends on Abstract Interface
// auth_repository_impl.dart
// import 'package:injectable/injectable.dart';
// import '../datasource/auth_remote_data_source.dart';
// import '../../domain/repositories/auth_repository.dart';

// @LazySingleton(as: AuthRepository)
// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource _remote;

//   AuthRepositoryImpl(this._remote);

//   @override
//   Future<void> someRepoFunction() async {
//     await _remote.signUp();
//   }
// }

// 3️⃣ Rebuild Injectable Configuration

// After updating annotations:

// flutter pub run build_runner build --delete-conflicting-outputs


// That regenerates app_component.config.dart so GetIt knows how to bind
// AuthRemoteDataSource → AuthRemoteDataSourceImpl.

// 4️⃣ Check Dependency Injection Setup

// In your app_component.dart:

// import 'package:get_it/get_it.dart';
// import 'package:injectable/injectable.dart';
// import 'app_component.config.dart';

// final locator = GetIt.instance;

// @InjectableInit()
// Future<void> configureDependencies() async => await locator.init();


// Call this once in your main method:

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await configureDependencies();
//   runApp(MyApp());
// }

// 🧠 TL;DR: Fix Summary
// Step	Action	Example
// 1	Annotate implementation	@LazySingleton(as: AuthRemoteDataSource)
// 2	Inject interface, not impl	final AuthRemoteDataSource _remote;
// 3	Rebuild injection	flutter pub run build_runner build --delete-conflicting-outputs
// 4	Ensure DI init	await configureDependencies();

// If you show me your current AuthRemoteDataSourceImpl and AuthRepositoryImpl files,
// I can mark the exact missing or mismatched line for you.

// Would you like to paste those two files here?

// ChatGPT can make mistakes. Check important info. See Cookie Preferences.