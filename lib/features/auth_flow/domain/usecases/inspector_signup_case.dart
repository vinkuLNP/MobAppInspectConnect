import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class InspectorSignUpParams extends Equatable {
  final InspectorSignUpLocalEntity inspectorSignUpLocalEntity;
  // final String name;
  // final String email;
  // final String password;
  // final String phoneNumber;
  // final String countryCode;
  // final String? isoCode;
  // final String certificateTypeId;
  // final String certificateExpiryDate;
  // final List<String> certificateDocuments;
  // final List<String> certificateAgencyIds;
  // final String country;
  // final String state;
  // final String city;
  // final String workHistoryDescription;
  // final String zipCode;
  // final String mailingAddress;
  // final String uploadedIdOrLicenseDocument;
  // final List<String> referenceDocuments;
  // final String profileImage;
  // final bool agreedToTerms;
  // final bool isTruthfully;
  // final int role;
  // final String deviceType;
  // final String deviceToken;
  // final Map<String, dynamic> location;

  const InspectorSignUpParams({
    // required this.name,
    // required this.email,
    // required this.password,
    // required this.phoneNumber,
    // required this.countryCode,
    // this.isoCode,
    // required this.certificateTypeId,
    // required this.certificateExpiryDate,
    // required this.certificateDocuments,
    // required this.certificateAgencyIds,
    // required this.country,
    // required this.state,
    // required this.city,
    // required this.workHistoryDescription,
    // required this.zipCode,
    // required this.mailingAddress,
    // required this.uploadedIdOrLicenseDocument,
    // required this.referenceDocuments,
    // required this.profileImage,
    // required this.agreedToTerms,
    // required this.isTruthfully,
    // required this.role,
    // required this.deviceType,
    // required this.deviceToken,
    // required this.location,
    required this.inspectorSignUpLocalEntity,
  });

  @override
  List<Object?> get props => [
    // name,
    // email,
    // password,
    // phoneNumber,
    // countryCode,
    // isoCode,
    // certificateTypeId,
    // certificateExpiryDate,
    // certificateDocuments,
    // certificateAgencyIds,
    // country,
    // state,
    // city,
    // workHistoryDescription,
    // zipCode,
    // mailingAddress,
    // uploadedIdOrLicenseDocument,
    // referenceDocuments,
    // profileImage,
    // agreedToTerms,
    // isTruthfully,
    // role,
    // deviceType,
    // deviceToken,
    // location,
    inspectorSignUpLocalEntity,
  ];
}

class InspectorSignUpUseCase
    extends BaseParamsUseCase<InspectorUser, InspectorSignUpParams> {
  final AuthRepository _repo;

  InspectorSignUpUseCase(this._repo);

  @override
  Future<ApiResultModel<InspectorUser>> call(InspectorSignUpParams? params) {
    return _repo.inspectorSignUp(
      inspectorSignUpLocalEntity: params!.inspectorSignUpLocalEntity,
    );
  }
}
