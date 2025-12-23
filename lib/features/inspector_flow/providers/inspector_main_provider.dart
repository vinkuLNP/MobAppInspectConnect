import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
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
        error: (e) {},
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
        error: (e) {},
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
      if (context.mounted) showPaymentSuccessDialog(context);
    } on StripeException catch (e) {
      log('⚠️ StripeException: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWidget(text: 'Payment canceled', color: Colors.white),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWidget(
              text: 'Payment failed: $e',
              color: Colors.white,
            ),
          ),
        );
      }
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
      return decoded;
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> checkUserApprovalStatus(BuildContext context) async {
    try {
      final localUser = await locator<AuthLocalDataSource>().getUser();
      if (localUser == null || localUser.authToken == null) {
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
          final mergedUser = localUser.mergeWithUserDetail(userDetail);
          await locator<AuthLocalDataSource>().saveUser(mergedUser);
          if (context.mounted) context.read<UserProvider>().setUser(mergedUser);

          status = userDetail.certificateApproved;
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: textWidget(
                text: 'Could not refresh user details',
                color: Colors.white,
              ),
            ),
          );
        },
      );

      return status;
    } catch (e) {
      return null;
    }
  }

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
            textWidget(
              text: "Payment Successful!",
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                final provider = context.read<InspectorDashboardProvider>();
                await provider.initializeUserState(context);
              },
              child: textWidget(text: 'Continue'),
            ),
          ],
        ),
      ),
    );
  }

  InspectorStatus status = InspectorStatus.initial;
  AuthUser? user;
  UserSubscriptionModel? subscription;

  Future<void> initializeUserState(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    status = InspectorStatus.initial;
    try {
      final localUser = await locator<AuthLocalDataSource>().getUser();

      if (localUser == null) {
        status = InspectorStatus.unverified;
        return;
      }

      if (context.mounted) {
        final userDetail = await fetchAndUpdateUserDetail(localUser, context);

        final mergedUser = localUser.mergeWithUserDetail(userDetail);

        user = AuthUser.fromLocalEntity(mergedUser);

        if (mergedUser.phoneOtpVerified != true) {
          status = InspectorStatus.unverified;
          return;
        }

        if (mergedUser.stripeSubscriptionStatus != 'active' ||
            mergedUser.currentSubscriptionId == null) {
          status = InspectorStatus.needsSubscription;
          await fetchSubscriptionPlans();
          return;
        }

        switch (mergedUser.certificateApproved) {
          case 0:
            status = InspectorStatus.underReview;
            break;
          case 1:
            status = InspectorStatus.approved;
            break;
          case 2:
            status = InspectorStatus.rejected;
            break;
          default:
        }
      }
    } catch (e) {
      log('[initializeUserState] Error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
]
  Future<UserDetail> fetchAndUpdateUserDetail(
    AuthUserLocalEntity localUser,
    BuildContext context,
  ) async {
    log('👤 [FETCH_USER_DETAIL] Started → localUserId=${localUser.id}');

    final getUserUseCase = locator<GetUserUseCase>();
    log('📡 [FETCH_USER_DETAIL] Calling GetUserUseCase');

    final result = await executeParamsUseCase<UserDetail, GetUserParams>(
      useCase: getUserUseCase,
      query: GetUserParams(userId: localUser.id.toString()),
      launchLoader: false,
    );

    log(
      '📥 [FETCH_USER_DETAIL] API response received → '
      'isNull=${result == null}',
    );

    late UserDetail detail;

    await result?.when(
      data: (userDetail) async {
        log(
          '✅ [FETCH_USER_DETAIL] Success → '
          'userId=${userDetail.id}',
        );

        detail = userDetail;

        log('🔀 [FETCH_USER_DETAIL] Merging local user with server data');
        final mergedUser = localUser.mergeWithUserDetail(userDetail);

        log('💾 [FETCH_USER_DETAIL] Saving merged user locally');
        await locator<AuthLocalDataSource>().saveUser(mergedUser);

        if (context.mounted) {
          log('🔄 [FETCH_USER_DETAIL] Updating UserProvider');
          context.read<UserProvider>().setUser(mergedUser);
        } else {
          log(
            '⚠️ [FETCH_USER_DETAIL] Context not mounted, '
            'skipping provider update',
          );
        }
      },
      error: (e) {
        log(
          '❌ [FETCH_USER_DETAIL] API failed → '
          'using local fallback. Error: $e',
        );

        detail = UserDetail(
          id: localUser.id.toString(),
          userId: localUser.userId.toString(),
          name: localUser.name,
          email: localUser.email,
          phoneNumber: localUser.phoneNumber,
          countryCode: localUser.countryCode,
          phoneOtpVerified: localUser.phoneOtpVerified,
          emailOtpVerified: localUser.emailOtpVerified,
          agreedToTerms: localUser.agreedToTerms,
          isTruthfully: localUser.isTruthfully,
          stripeSubscriptionStatus: localUser.stripeSubscriptionStatus,
          currentSubscriptionId: localUser.currentSubscriptionId != null
              ? CurrentSubscription(id: localUser.currentSubscriptionId)
              : null,
          certificateApproved: localUser.certificateApproved,
          location: localUser.latitude != null && localUser.longitude != null
              ? Location(
                  type: 'Point',
                  locationName: localUser.locationName,
                  coordinates: [localUser.latitude!, localUser.longitude!],
                )
              : null,
        );

        log(
          '🧩 [FETCH_USER_DETAIL] Fallback UserDetail created from local data',
        );
      },
    );

    log(
      '🏁 [FETCH_USER_DETAIL] Completed → returning UserDetail '
      '(userId=${detail.id})',
    );

    return detail;
  }
}
