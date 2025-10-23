import 'package:clean_architecture/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<ApiResultModel<AuthUser>> signIn({
    required String email,
    required String password,
    required String deviceToken,
    required String deviceType,
  });

   Future<ApiResultModel<AuthUser>> signUp({
    required int role,
  required String email,
  required String name,
  required String phoneNumber,
  required String countryCode,
  required String password,
  required String deviceToken,
  required String deviceType,
  required String mailingAddress,
  required bool agreedToTerms,
  required bool isTruthfully,
  required Map<String, dynamic> location,
  });
 Future<ApiResultModel<AuthUser>> verifyOtp({
    required String phoneOtp,
    required String phoneNumber,
    required String countryCode,
  });

   Future<ApiResultModel<AuthUser>> resendOtp({
    required String phoneNumber,
    required String countryCode,
  });

}