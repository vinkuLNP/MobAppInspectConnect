import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/services/payment_services/payment_purpose.dart';
import 'package:inspect_connect/core/di/services/payment_services/payment_request.dart';
import 'package:inspect_connect/core/utils/app_widgets/card_payment_sheet.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/data/models/document_model.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/get_user__usercase.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/payment_intent_response_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/user_subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/payment_intent_dto.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/user_subscription_by_id.dart';
import 'package:inspect_connect/features/inspector_flow/domain/enum/inspector_documents_enum.dart';
import 'package:inspect_connect/features/inspector_flow/domain/enum/inspector_status.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/get_subscription_plans_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/get_user_subscription_detail_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/payment_intent_usecase.dart';
import 'package:inspect_connect/main.dart';
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
    required int isManual,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
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
                isManual: isManual.toString(),
              ),
            ),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          userSubscriptionModel = response;
          log("resposne of subscriptionas plan----------$response");
          showCardPaymentSheet(
            context: context,
            provider: context.read<WalletProvider>(),
            request: PaymentRequest(
              purpose: PaymentPurpose.subscription,
              amount: response.amount.toDouble().toString(),
              priceId: response.priceId,
              subscriptionId: response.stripeSubscriptionId,
              totalAmount: plan.amount.toDouble().toString(),
              type: 0,
              device: '1',
            ),
          );
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
      log("resposne of subscriptionas plan-----createPaymentIntent called----");

      final intentdto = CreatePaymentIntentDto(
        paymentType: 'subscription',
        priceId: plan.priceId,
        subscriptionId: plan.stripeSubscriptionId,
        totalAmount: plan.amount.toDouble().toString(),
        type: 0,
        device: 1,
      );
      final getPaymentIntentUseCase = locator<GetPaymentIntentUseCase>();
      final state =
          await executeParamsUseCase<
            PaymentIntentModel,
            GetPaymentIntnetParams
          >(
            useCase: getPaymentIntentUseCase,
            query: GetPaymentIntnetParams(createPaymentIntentDto: intentdto),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          final intentResponse = response;
          log("resposne of subscriptionas plan----------$response");
          final clientSecret = intentResponse.clientSecret;
          if (clientSecret == "" || clientSecret.isEmpty) {
            throw Exception('Missing client secret from API');
          }

          await Stripe.instance.confirmPayment(
            paymentIntentClientSecret: clientSecret,
            data: const PaymentMethodParams.card(
              paymentMethodData: PaymentMethodData(),
            ),
          );

          if (context.mounted) showPaymentSuccessDialog(context);
        },
        error: (e) {},
      );
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

                initializeUserState();
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

  Future<void> initializeUserState() async {
    final BuildContext? context =
        rootNavigatorKey.currentState?.overlay?.context;
    isLoading = true;
    notifyListeners();
    status = InspectorStatus.initial;
    try {
      final localUser = await locator<AuthLocalDataSource>().getUser();

      if (localUser == null) {
        status = InspectorStatus.unverified;
        return;
      }

      if (context!.mounted) {
        log(
          '----localUser------?>>> certioficateApproved ${localUser.certificateApproved}',
        );
        final userDetail = await fetchAndUpdateUserDetail(localUser, context);

        final mergedUser = localUser.mergeWithUserDetail(userDetail);
        updateReviewState(mergedUser.toDomainEntity());

        log(
          '----mergedUser------?>>> certioficateApproved ${mergedUser.certificateApproved}',
        );

        if (mergedUser.phoneOtpVerified != true) {
          status = InspectorStatus.unverified;
          return;
        }

        if (mergedUser.stripeSubscriptionStatus == 'inactive' ||
            mergedUser.stripeSubscriptionStatus == 'past_due' ||
            mergedUser.stripeSubscriptionStatus == 'canceled' ||
            mergedUser.currentSubscriptionId == null ||
            mergedUser.currentSubscriptionId!.id == '') {
          status = InspectorStatus.needsSubscription;
          await fetchSubscriptionPlans();
          return;
        }

        switch (reviewStatus) {
          case ReviewStatus.pending:
            log('🟠 Status → UNDER_REVIEW');
            status = InspectorStatus.underReview;
            break;

          case ReviewStatus.approved:
            log('🟢 Status → APPROVED');
            status = InspectorStatus.approved;
            break;

          case ReviewStatus.rejected:
            log('🔴 Status → REJECTED');
            status = InspectorStatus.rejected;
            break;
        }
      }
    } catch (e) {
      log('[initializeUserState] Error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ReviewStatus reviewStatus = ReviewStatus.pending;
  List<UserDocument> rejectedDocuments = [];
  String rejectedReason = '';

  void updateReviewState(AuthUser user) {
    reviewStatus = deriveReviewStatus(user);

    rejectedDocuments =
        user.documents?.where((d) => d.adminApproval == 2).toList() ?? [];
    rejectedReason = user.rejectedReason ?? '';
  }

  Future<UserDetail> fetchAndUpdateUserDetail(
    AuthUserLocalEntity localUser,
    BuildContext contextDetail,
  ) async {
    final BuildContext? context =
        rootNavigatorKey.currentState?.overlay?.context;
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

        if (context!.mounted) {
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
        detail = UserDetail.fromJson(localUser.toDomainEntity().toJson());

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
