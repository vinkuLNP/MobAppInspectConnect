import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/payment_intent_response_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/user_subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/payment_intent_dto.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/user_subscription_by_id.dart';

abstract class InspectorRepository {
  Future<ApiResultModel<List<SubscriptionPlanModel>>> fetchSubscriptionPlans();
  Future<ApiResultModel<UserSubscriptionModel>> getUserSubscriptionModel({
    required UserSubscriptionByIdDto userSubscriptionById,
  });
  Future<ApiResultModel<PaymentIntentModel>> getPaymentIntent({
    required CreatePaymentIntentDto paymentIntentDto,
  });
}
