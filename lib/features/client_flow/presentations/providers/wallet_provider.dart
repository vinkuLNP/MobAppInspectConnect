
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/user_payment_list_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/wallet_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_user_payments_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_user_wallet_amount_usecase.dart';


class WalletProvider extends BaseViewModel {
  WalletModel? walletModel;
  List<PaymentEntity> payments = [];
   WalletState walletState = WalletState.idle;

  int _currentPage = 1;
  int _totalPages = 1;
  bool isFetching = false;

  final int _limit = 10;
 String? errorMessage;
 Future<void> init({required BuildContext context}) async {
  try {
    walletState = WalletState.loading;
    notifyListeners();

    await Future.wait([
      getUserWallet(context: context),
      getPaymentList(context: context, reset: true),
    ]);

    walletState = WalletState.loaded;
  } catch (e) {
    walletState = WalletState.error;
    errorMessage = e.toString();
  }
  notifyListeners();
}

  Future<void> refreshAll(BuildContext context) async {
    payments.clear();
    _currentPage = 1;
    _totalPages = 1;
    await getUserWallet(context: context);
  if(context.mounted)  await getPaymentList(context: context, reset: true);
  }

  Future<void> getUserWallet({required BuildContext context}) async {
    final user = await locator<AuthLocalDataSource>().getUser();
    if (user?.authToken == null) return;

    final useCase = locator<GetUserWalletAmountUseCase>();
    final state = await executeParamsUseCase<WalletModel, GetUserWalletAmountParams>(
      useCase: useCase,
      query: GetUserWalletAmountParams(),
      launchLoader: false,
    );

    state?.when(
      data: (res) {
        walletModel = res;
        notifyListeners();
      },
      error: (e) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:   textWidget(text: e.message ?? 'Failed to fetch wallet',color: Colors.white)),
      ),
    );
  }

  Future<void> getPaymentList({
    required BuildContext context,
    bool reset = false,
  }) async {
    if (isFetching || (_currentPage > _totalPages && !reset)) return;

    isFetching = true;
    notifyListeners();

    final user = await locator<AuthLocalDataSource>().getUser();
    if (user?.authToken == null) return;

    final useCase = locator<GetUserPaymentsListUseCase>();
    final state = await executeParamsUseCase<PaymentsBodyModel, GetUserPaymentsListParams>(
      useCase: useCase,
      query: GetUserPaymentsListParams(
        page: _currentPage,
        limit: _limit,
      ),
      launchLoader: false,
    );

    state?.when(
      data: (res) {
        if (reset) payments.clear();
        payments.addAll(res.payments);
        _totalPages = res.totalPages;
        _currentPage++;
        notifyListeners();
      },
      error: (e) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:   textWidget(text: e.message ?? 'Failed to fetch payments',color: Colors.white)),
      ),
    );

    isFetching = false;
    notifyListeners();
  }

  Future<void> loadMorePayments(BuildContext context) async {
    await getPaymentList(context: context);
  }

  
}



enum WalletState { idle, loading, loaded, error }
