import 'dart:async';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:flutter/cupertino.dart';

class BaseViewModel extends ChangeNotifier {
  final StreamController<bool> _toggleLoading =
      StreamController<bool>.broadcast();

  StreamController<bool> get toggleLoading => _toggleLoading;

  Future<ApiResultState<DataType>?> executeParamsUseCase<DataType, Params>({
    required BaseParamsUseCase<DataType, Params> useCase,
    Params? query,
    bool launchLoader = true,
  }) async {
    showLoadingIndicator(launchLoader);
    final ApiResultModel<DataType> apiResult = await useCase(query);
    return apiResult.when(
      success: (DataType data) {
        showLoadingIndicator(false);
        return ApiResultState<DataType>.data(data: data);
      },
      failure: (ErrorResultModel errorResultEntity) {
        showLoadingIndicator(false);
        return ApiResultState<DataType>.error(
          errorResultModel: ErrorResultModel(
            message: errorResultEntity.message,
            statusCode: errorResultEntity.statusCode,
          ),
        );
      },
    );
  }

  void showLoadingIndicator(bool show) {
    _toggleLoading.add(show);
  }

  void onDispose() {}

  @override
  void dispose() {
    _toggleLoading.close();
    onDispose();
    super.dispose();
  }
}
