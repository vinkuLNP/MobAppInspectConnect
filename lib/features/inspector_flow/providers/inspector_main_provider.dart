import 'dart:convert';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/get_user__usercase.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/subscription_model.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/user_subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/user_subscription_by_id.dart';
import 'package:inspect_connect/features/inspector_flow/domain/enum/inspector_status.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/get_subscription_plans_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/get_user_subscription_detail_usecase.dart';
import 'package:provider/provider.dart';

class InspectorDashboardProvider extends BaseViewModel {
  bool isLoading = false;
  String? errorMessage;
  List<SubscriptionPlanModel> subscriptionPlans = [];
  UserSubscriptionModel? userSubscriptionModel;

  bool isProcessingPayment = false;

  Future<void> fetchSubscriptionPlans() async {
    try {
      isLoading = true;
      notifyListeners();
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final getSubscriptionPlansUseCase =
          locator<GetSubscriptionPlansUseCase>();
      final state =
          await executeParamsUseCase<
            List<SubscriptionPlanModel>,
            GetSubscriptionPlansParams
          >(
            useCase: getSubscriptionPlansUseCase,

            query: GetSubscriptionPlansParams(),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          subscriptionPlans = response;
        },
        error: (e) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(e.message ?? 'Fetching Booking Detail failed'),
          //   ),
          // );
        },
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserSubscriptionModel({
    required BuildContext context,
    required SubscriptionPlanModel plan,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final getSubscriptionPlansUseCase =
          locator<GetUserSubscriptionDetailUseCase>();
      final state =
          await executeParamsUseCase<
            UserSubscriptionModel,
            GetUserSubscriptionDetailParams
          >(
            useCase: getSubscriptionPlansUseCase,

            query: GetUserSubscriptionDetailParams(
              userSubscriptionByIdDto: UserSubscriptionByIdDto(
                planId: plan.id,
                isManual: '0',
              ),
            ),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          userSubscriptionModel = response;

          startPayment(context: context, plan: userSubscriptionModel!);
        },
        error: (e) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(e.message ?? 'Fetching Booking Detail failed'),
          //   ),
          // );
        },
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startPayment({
    required BuildContext context,
    required UserSubscriptionModel plan,
  }) async {
    try {
      isProcessingPayment = true;
      notifyListeners();

      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found');
      }

      /*    final intentResponse = await createPaymentIntent(
        user.authToken!,
        plan.amount!.toDouble(),
        plan.id!,
        plan.stripeSubscriptionId,
      );

      final clientSecret = intentResponse['body']?['clientSecret'];
      if (clientSecret == null) {
        throw Exception('Missing client secret from API');
      }

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );
*/
      showPaymentSuccessDialog(context);
    } on StripeException catch (e) {
      log('⚠️ StripeException: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment canceled')));
    } catch (e, st) {
      log('❌ Payment error: $e\n$st');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      isProcessingPayment = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    String token,
    double amount,
    String priceId,
    String subscriptionId,
  ) async {
    try {
      log(
        'totalAmount ${amount.toString()},priceId ${priceId},paymentType $subscriptionId,device ${1},subscriptionId ${subscriptionId},  ',
      );
      final url = Uri.parse('$devBaseUrl/payments/paymentIntent');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'totalAmount': amount.toString(),
          'priceId': priceId,
          'paymentType': 'subscription',
          'device': '1',
          'subscriptionId': subscriptionId,
          'type': '0',
        },
      );

      final decoded = json.decode(response.body);
      log("📩 createPaymentIntent response: $decoded");
      return decoded;
    } catch (e, st) {
      log('❌ createPaymentIntent error: $e\n$st');
      rethrow;
    }
  }

  Future<int?> checkUserApprovalStatus(BuildContext context) async {
    try {
      final localUser = await locator<AuthLocalDataSource>().getUser();
      if (localUser == null || localUser.authToken == null) {
        log('[CHECK_USER_STATUS] ❌ No local user/token found');
        return null;
      }

      final getUserUseCase = locator<GetUserUseCase>();
      final result = await executeParamsUseCase<UserDetail, GetUserParams>(
        useCase: getUserUseCase,
        query: GetUserParams(userId: localUser.id.toString()),
        launchLoader: true,
      );

      int? status;

      await result?.when(
        data: (userDetail) async {
          log('[CHECK_USER_STATUS] ✅ Got updated user detail');
          final mergedUser = localUser.mergeWithUserDetail(userDetail);
          await locator<AuthLocalDataSource>().saveUser(mergedUser);
          context.read<UserProvider>().setUser(mergedUser);

          status = userDetail.approvalStatusByAdmin;
        },
        error: (e) {
          log('[CHECK_USER_STATUS] ❌ Failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not refresh user details')),
          );
        },
      );

      return status;
    } catch (e, st) {
      log('[CHECK_USER_STATUS] ❌ Exception: $e\n$st');
      return null;
    }
  }

  // void showPaymentSuccessDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children:  [
  //           Icon(Icons.check_circle, color: Colors.green, size: 70),
  //           SizedBox(height: 10),
  //           Text(
  //             "Payment Successful!",
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //           ),
  //             const SizedBox(height: 16),
  //         ElevatedButton(
  //           onPressed: () async {
  //             Navigator.pop(context); // close dialog
  //             await checkUserApprovalStatus(context);
  //           },
  //           child: const Text('Continue'),
  //         ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 70),
            const SizedBox(height: 10),
            const Text(
              "Payment Successful!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                // ✅ Refresh everything
                final provider = context.read<InspectorDashboardProvider>();
                await provider.initializeUserState(context);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchUserDetail({
    required AuthUser user,
    required BuildContext context,
  }) async {
    log('[FETCH_USER_DETAIL] Fetching user details for userId=${user.id}');

    // Get existing local user first
    final existingUser = await locator<AuthLocalDataSource>().getUser();

    final localUser = user.toLocalEntity();

    // ✅ Preserve token if API user doesn’t include one
    if (localUser.authToken == null || localUser.authToken!.isEmpty) {
      log('[FETCH_USER_DETAIL] ⚠️ No token in API user — reusing local token.');
      localUser.authToken = existingUser?.authToken;
    }

    log(
      '[FETCH_USER_DETAIL] Local entity before save: token=${localUser.authToken}, name=${localUser.name}',
    );

    await locator<AuthLocalDataSource>().saveUser(localUser);
    log('[FETCH_USER_DETAIL] Saved local user.');

    final userProvider = context.read<UserProvider>();
    await userProvider.setUser(localUser);
    await userProvider.loadUser();

    log(
      '[FETCH_USER_DETAIL] Local user loaded into provider: id=${user.id}, token=${localUser.authToken}',
    );
    final fetchUserUseCase = locator<GetUserUseCase>();
    final userState = await executeParamsUseCase<UserDetail, GetUserParams>(
      useCase: fetchUserUseCase,
      query: GetUserParams(userId: user.id),
      launchLoader: true,
    );

    userState?.when(
      data: (userData) async {
        log(
          '[FETCH_USER_DETAIL] ✅ Received user detail from API: ${userData.name} (${userData.email})',
        );

        final mergedUser = localUser.mergeWithUserDetail(userData);
        log(
          '[FETCH_USER_DETAIL] Merged user detail: token=${mergedUser.authToken}, name=${mergedUser.name}',
        );

        await locator<AuthLocalDataSource>().saveUser(mergedUser);
        log('[FETCH_USER_DETAIL] ✅ User detail saved locally after merge.');

        await userProvider.setUser(mergedUser);
        log('[FETCH_USER_DETAIL] ✅ User updated in provider.');
      },
      error: (e) {
        log('[FETCH_USER_DETAIL] ❌ Failed to fetch user detail: ${e.message}');

        context.router.replaceAll([const OnBoardingRoute()]);
      },
    );
  }

  InspectorStatus status = InspectorStatus.unverified;
  AuthUser? user;
  UserSubscriptionModel? subscription;

  Future<void> initializeUserState(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final localUser = await locator<AuthLocalDataSource>().getUser();
      if (localUser == null) {
        status = InspectorStatus.unverified;
        return;
      }

      user = localUser.toDomainEntity();

      // if (localUser.phoneOtpVerified != true) {
      //   status = InspectorStatus.unverified;
      //   return;
      // }

      // if (localUser.stripeSubscriptionStatus == null ||
      //     localUser.currentSubscriptionId == null) {
      //   status = InspectorStatus.needsSubscription;
      //   await fetchSubscriptionPlans();
      //   return;
      // }

      // if (localUser.stripeSubscriptionStatus == 'active' &&
      //     localUser.currentSubscriptionId != null) {
      //   final userDetail = await fetchAndUpdateUserDetail(localUser, context);

      //   if (userDetail.approvalStatusByAdmin == 0) {
      //     status = InspectorStatus.underReview;
      //   } else if (userDetail.approvalStatusByAdmin == 2) {
      //     status = InspectorStatus.rejected;
      //   } else if (userDetail.approvalStatusByAdmin == 1) {
          status = InspectorStatus.approved;
      //   }
      // }
    } catch (e) {
      debugPrint('initializeUserState error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserDetail> fetchAndUpdateUserDetail(
    AuthUserLocalEntity localUser,
    BuildContext context,
  ) async {
    final getUserUseCase = locator<GetUserUseCase>();
    final result = await executeParamsUseCase<UserDetail, GetUserParams>(
      useCase: getUserUseCase,
      query: GetUserParams(userId: localUser.id.toString()),
      launchLoader: false,
    );

    late UserDetail detail;

    result?.when(
      data: (userDetail) async {
        detail = userDetail;
        final mergedUser = localUser.mergeWithUserDetail(userDetail);
        await locator<AuthLocalDataSource>().saveUser(mergedUser);
        context.read<UserProvider>().setUser(mergedUser);
      },
      error: (e) => debugPrint('Failed to fetch user detail: ${e.message}'),
    );

    return detail;
  }
}
