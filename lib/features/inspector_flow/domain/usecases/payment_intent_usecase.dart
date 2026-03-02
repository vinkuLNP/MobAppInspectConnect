import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/payment_intent_response_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/payment_intent_dto.dart';
import 'package:inspect_connect/features/inspector_flow/domain/repositories/inspector_repository.dart';

class GetPaymentIntnetParams extends Equatable {
  final CreatePaymentIntentDto createPaymentIntentDto;

  const GetPaymentIntnetParams({required this.createPaymentIntentDto});

  @override
  List<Object?> get props => [createPaymentIntentDto];
}

class GetPaymentIntentUseCase
    extends BaseParamsUseCase<PaymentIntentModel, GetPaymentIntnetParams> {
  final InspectorRepository _repo;
  GetPaymentIntentUseCase(this._repo);

  @override
  Future<ApiResultModel<PaymentIntentModel>> call(GetPaymentIntnetParams? p) =>
      _repo.getPaymentIntent(paymentIntentDto: p!.createPaymentIntentDto);
}
