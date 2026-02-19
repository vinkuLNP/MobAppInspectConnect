import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/datasources/remote_datasource/inspector_api_datasource.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/payment_intent_response_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/user_subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/payment_intent_dto.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/user_subscription_by_id.dart';
import 'package:inspect_connect/features/inspector_flow/domain/repositories/inspector_repository.dart';

class InspectorRepositoryImpl implements InspectorRepository {
  final InspectorRemoteDataSource remote;

  InspectorRepositoryImpl(this.remote);

  @override
  Future<ApiResultModel<List<SubscriptionPlanModel>>> fetchSubscriptionPlans() {
    return remote.fetchSubscriptionPlans();
  }

  @override
  Future<ApiResultModel<UserSubscriptionModel>> getUserSubscriptionModel({
    required UserSubscriptionByIdDto userSubscriptionById,
  }) {
    return remote.getUserSubscriptionModel(
      userSubscriptionById: userSubscriptionById,
    );
  }

  @override
  Future<ApiResultModel<PaymentIntentModel>> getPaymentIntent({
    required CreatePaymentIntentDto paymentIntentDto,
  }) {
    return remote.getPaymentIntent(paymentIntentDto: paymentIntentDto);
  }
}
