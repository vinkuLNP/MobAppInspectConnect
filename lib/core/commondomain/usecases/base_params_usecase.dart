import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:equatable/equatable.dart';

abstract class BaseParamsUseCase<ReturnDataType, Request> {
  Future<ApiResultModel<ReturnDataType>> call(Request? params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => <Object>[];
}
