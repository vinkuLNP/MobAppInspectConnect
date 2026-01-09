import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/services/payment_services/payment_purpose.dart';
import 'package:inspect_connect/core/di/services/payment_services/payment_request.dart';
import 'package:inspect_connect/core/di/services/payment_services/stripe_service.dart';
import 'package:inspect_connect/features/client_flow/data/models/user_payment_list_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/wallet_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/enums/wallet_state_enum.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_user_payments_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_user_wallet_amount_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/payment_intent_response_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/payment_intent_dto.dart';
import 'package:inspect_connect/features/inspector_flow/domain/usecases/payment_intent_usecase.dart';

class WalletProvider extends BaseViewModel {
  WalletModel? wallet;
  final List<PaymentEntity> payments = [];

  WalletState state = WalletState.idle;
  String? error;

  int _page = 1;
  int _totalPages = 1;
  final int _limit = 10;
  bool isFetching = false;

  final StripeService _stripeService = locator<StripeService>();

  Future<void> init(BuildContext context) async {
    try {
      state = WalletState.loading;
      notifyListeners();

      await Future.wait([
        fetchWallet(context),
        fetchPayments(context, reset: true),
      ]);

      state = WalletState.loaded;
    } catch (e) {
      state = WalletState.error;
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchWallet(BuildContext context) async {
    final useCase = locator<GetUserWalletAmountUseCase>();

    final result =
        await executeParamsUseCase<WalletModel, GetUserWalletAmountParams>(
          useCase: useCase,
          query: GetUserWalletAmountParams(),
          launchLoader: false,
        );

    result?.when(data: (res) => wallet = res, error: (e) => error = e.message);

    notifyListeners();
  }

  Future<void> loadMorePayments(BuildContext context) async {
    await fetchPayments(context);
  }

  Future<void> fetchPayments(BuildContext context, {bool reset = false}) async {
    if (isFetching || (_page > _totalPages && !reset)) return;

    isFetching = true;
    notifyListeners();

    final useCase = locator<GetUserPaymentsListUseCase>();

    final result =
        await executeParamsUseCase<
          PaymentsBodyModel,
          GetUserPaymentsListParams
        >(
          useCase: useCase,
          query: GetUserPaymentsListParams(page: _page, limit: _limit),
          launchLoader: false,
        );

    result?.when(
      data: (res) {
        if (reset) payments.clear();
        payments.addAll(res.payments);
        _totalPages = res.totalPages;
        _page++;
      },
      error: (e) => error = e.message,
    );

    isFetching = false;
    notifyListeners();
  }

  Future<String> createPaymentIntent(PaymentRequest request) async {
    late CreatePaymentIntentDto dto;

    switch (request.purpose) {
      case PaymentPurpose.addMoneyToWallet:
        dto = CreatePaymentIntentDto(
          paymentType: 'payment-plain',
          totalAmount: request.amount,
          type: 0,
          device: '1',
        );
        break;

      case PaymentPurpose.subscription:
        dto = CreatePaymentIntentDto(
          paymentType: 'subscription',
          totalAmount: request.amount,
          type: 1,
          device: '1',
          subscriptionId: request.referenceId,
        );
        break;

      case PaymentPurpose.booking:
        dto = CreatePaymentIntentDto(
          paymentType: 'booking',
          totalAmount: request.amount,
          type: 2,
          device: '1',
        );
        break;

      case PaymentPurpose.withdrawMoney:
        dto = CreatePaymentIntentDto(
          paymentType: 'withdraw',
          totalAmount: request.amount,
          type: 3,
          device: '1',
        );
        break;
    }

    final useCase = locator<GetPaymentIntentUseCase>();

    final result =
        await executeParamsUseCase<PaymentIntentModel, GetPaymentIntnetParams>(
          useCase: useCase,
          query: GetPaymentIntnetParams(createPaymentIntentDto: dto),
          launchLoader: true,
        );

    late String clientSecret;

    result?.when(
      data: (res) => clientSecret = res.clientSecret,
      error: (e) => throw Exception(e.message),
    );

    return clientSecret;
  }

  Future<void> confirmPayment(String clientSecret) async {
    await _stripeService.confirmCardPayment(clientSecret: clientSecret);
  }

  Future<void> refreshAll(BuildContext context) async {
    _page = 1;
    _totalPages = 1;
    payments.clear();

    await fetchWallet(context);
    await fetchPayments(context, reset: true);
  }
}
