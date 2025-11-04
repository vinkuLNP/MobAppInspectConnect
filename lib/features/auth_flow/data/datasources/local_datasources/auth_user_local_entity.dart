import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AuthUserLocalEntity {
  int id = 0;
  String? token;
  String? name;
  String? email;
  String? phoneNumber;
  String? countryCode;
  String? mailingAddress;
  int? role;
  int? status;
  bool? phoneOtpVerified;
  bool? emailOtpVerified;
  bool? agreedToTerms;
  bool? isTruthfully;
  int? approvalStatusByAdmin;
  String? rejectedReason;
  String? stripeCustomerId;
  String? stripeAccountId;
  bool? stripePayoutsEnabled;
  bool? stripeTransfersActive;
  int? currentSubscriptionTrialDays;
  int? currentSubscriptionAutoRenew;
  String? currentSubscriptionId;
  String? stripeSubscriptionStatus;
  String? walletId;
  String? locationName;
  double? latitude;
  double? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? loginTime;
  @Backlink()
  final devices = ToMany<AuthUserDeviceEntity>();

  AuthUserLocalEntity({
    this.token,
    this.name,
    this.email,
    this.phoneNumber,
    this.countryCode,
    this.mailingAddress,
    this.role,
    this.status,
    this.phoneOtpVerified,
    this.emailOtpVerified,
    this.agreedToTerms,
    this.isTruthfully,
    this.approvalStatusByAdmin,
    this.rejectedReason,
    this.stripeCustomerId,
    this.stripeAccountId,
    this.stripePayoutsEnabled,
    this.stripeTransfersActive,
    this.currentSubscriptionTrialDays,
    this.currentSubscriptionAutoRenew,
    this.currentSubscriptionId,
    this.stripeSubscriptionStatus,
    this.walletId,
    this.locationName,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.loginTime,
  });
  AuthUserLocalEntity copyWith({
    String? name,
    String? email,
    String? token,
    int? role,
    String? phoneNumber,
    String? mailingAddress,
    String? countryCode,
    bool? phoneOtpVerified,
    bool? emailOtpVerified,
    bool? agreedToTerms,
    bool? isTruthfully,
    String? walletId,
    String? stripeAccountId,
    String? stripeCustomerId,
    UserLocation? location,
    List<UserDevice>? devices,
  }) {
    return AuthUserLocalEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      phoneOtpVerified: phoneOtpVerified ?? this.phoneOtpVerified,
      emailOtpVerified: emailOtpVerified ?? this.emailOtpVerified,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      isTruthfully: isTruthfully ?? this.isTruthfully,
      walletId: walletId ?? this.walletId,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      mailingAddress: mailingAddress ?? this.mailingAddress,
    );
  }

  factory AuthUserLocalEntity.fromApiResponse(Map<String, dynamic> response) {
    Map<String, dynamic>? user = response['body']?['user'] ?? response['body'];
    String? authToken =
        response['body']?['authToken'] ??
        response['body']?['user']?['authToken'];
    Map<String, dynamic>? location = user?['location'];
    double? latitude;
    double? longitude;
    String? locationName;
    if (location != null && location['coordinates'] != null) {
      longitude = (location['coordinates'][0] as num?)?.toDouble();
      latitude = (location['coordinates'][1] as num?)?.toDouble();
      locationName = location['locationName'];
    }

    return AuthUserLocalEntity(
      token: authToken,
      name: user?['name'],
      email: user?['email'],
      phoneNumber: user?['phoneNumber'],
      countryCode: user?['countryCode'],
      mailingAddress: user?['mailingAddress'],
      role: user?['role'],
      status: user?['status'],
      phoneOtpVerified: user?['phoneOtpVerified'],
      emailOtpVerified: user?['emailOtpVerified'],
      agreedToTerms: user?['agreedToTerms'],
      isTruthfully: user?['isTruthfully'],
      approvalStatusByAdmin: user?['approvalStatusByAdmin'],
      rejectedReason: user?['rejectedReason'],
      stripeCustomerId: user?['stripeCustomerId'],
      stripeAccountId: user?['stripeAccountId'],
      stripePayoutsEnabled: user?['stripePayoutsEnabled'],
      stripeTransfersActive: user?['stripeTransfersActive'],
      currentSubscriptionTrialDays: user?['currentSubscriptionTrialDays'],
      currentSubscriptionAutoRenew: user?['currentSubscriptionAutoRenew'],
      currentSubscriptionId: user?['currentSubscriptionId'],
      stripeSubscriptionStatus: user?['stripeSubscriptionStatus'],
      walletId: user?['walletId'],
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      createdAt: user?['createdAt'] != null
          ? DateTime.parse(user!['createdAt'])
          : null,
      updatedAt: user?['updatedAt'] != null
          ? DateTime.parse(user!['updatedAt'])
          : null,
      loginTime: user?['loginTime'] != null
          ? DateTime.parse(user!['loginTime'])
          : null,
    );
  }
}

@Entity()
class AuthUserDeviceEntity {
  int id = 0;
  String? deviceToken;
  String? deviceType;

  final user = ToOne<AuthUserLocalEntity>();

  AuthUserDeviceEntity({this.deviceToken, this.deviceType});
}

extension AuthUserLocalMapping on AuthUserLocalEntity {
  AuthUser toDomainEntity() {
    return AuthUser(
      id: id.toString(),
      fullName: name ?? '',
      emailHashed: email ?? '',
      token: token ?? '',
      role: role,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      phoneOtpVerified: phoneOtpVerified ?? false,
      emailOtpVerified: emailOtpVerified ?? false,
      agreedToTerms: agreedToTerms ?? false,
      isTruthfully: isTruthfully ?? false,
      walletId: walletId,
      stripeAccountId: stripeAccountId,
      stripeCustomerId: stripeCustomerId,
      location: (latitude != null && longitude != null)
          ? UserLocation(
              name: locationName ?? '',
              lat: latitude!,
              lng: longitude!,
            )
          : null,
      devices: devices.map((d) => d.toDomainEntity()).toList(),
    );
  }
}

extension AuthUserDeviceMapping on AuthUserDeviceEntity {
  UserDevice toDomainEntity() {
    return UserDevice(token: deviceToken, type: deviceType);
  }
}

extension AuthUserLocalEntityMergeData on AuthUserLocalEntity {
  AuthUserLocalEntity mergeWithNewData(AuthUserLocalEntity newUser) {
    final merged =
        AuthUserLocalEntity(
            name: newUser.name ?? name,
            email: newUser.email ?? email,
            phoneNumber: newUser.phoneNumber ?? phoneNumber,
            countryCode: newUser.countryCode ?? countryCode,
            role: newUser.role ?? role,
            token: (newUser.token?.isNotEmpty ?? false) ? newUser.token : token,
            agreedToTerms: newUser.agreedToTerms ?? agreedToTerms,
            isTruthfully: newUser.isTruthfully ?? isTruthfully,
            mailingAddress: newUser.mailingAddress ?? mailingAddress,
            status: newUser.status ?? status,
            phoneOtpVerified: newUser.phoneOtpVerified ?? phoneOtpVerified,
            emailOtpVerified: newUser.emailOtpVerified ?? emailOtpVerified,
            approvalStatusByAdmin:
                newUser.approvalStatusByAdmin ?? approvalStatusByAdmin,
            rejectedReason: newUser.rejectedReason ?? rejectedReason,
            stripeCustomerId: newUser.stripeCustomerId ?? stripeCustomerId,
            stripeAccountId: newUser.stripeAccountId ?? stripeAccountId,
            stripePayoutsEnabled:
                newUser.stripePayoutsEnabled ?? stripePayoutsEnabled,
            stripeTransfersActive:
                newUser.stripeTransfersActive ?? stripeTransfersActive,
            currentSubscriptionTrialDays:
                newUser.currentSubscriptionTrialDays ??
                currentSubscriptionTrialDays,
            currentSubscriptionAutoRenew:
                newUser.currentSubscriptionAutoRenew ??
                currentSubscriptionAutoRenew,
            currentSubscriptionId:
                newUser.currentSubscriptionId ?? currentSubscriptionId,
            stripeSubscriptionStatus:
                newUser.stripeSubscriptionStatus ?? stripeSubscriptionStatus,
            walletId: newUser.walletId ?? walletId,
            locationName: newUser.locationName ?? locationName,
            latitude: newUser.latitude ?? latitude,
            longitude: newUser.longitude ?? longitude,
            createdAt: createdAt ?? newUser.createdAt,
            updatedAt: newUser.updatedAt ?? updatedAt,
            loginTime: newUser.loginTime ?? loginTime,
          )
          ..id = id
          ..devices.addAll(
            newUser.devices.isNotEmpty ? newUser.devices : devices,
          );

    return merged;
  }
}
