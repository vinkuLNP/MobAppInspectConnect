import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

class AuthUser {
  final String id;
  final String fullName;
  final String emailHashed;
  final String token;
  final int? role;
  final String? phoneNumber;
  final String? countryCode;
  final bool phoneOtpVerified;
  final bool emailOtpVerified;
  final bool agreedToTerms;
  final bool isTruthfully;
  final String? walletId;
  final String? stripeAccountId;
  final String? stripeCustomerId;
  final UserLocation? location;
  final List<UserDevice> devices;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.emailHashed,
    required this.token,
    this.role,
    this.phoneNumber,
    this.countryCode,
    this.phoneOtpVerified = false,
    this.emailOtpVerified = false,
    this.agreedToTerms = false,
    this.isTruthfully = false,
    this.walletId,
    this.stripeAccountId,
    this.stripeCustomerId,
    this.location,
    this.devices = const [],
  });


  
}



extension AuthUserMapping on AuthUser {
  AuthUserLocalEntity toLocalEntity() {
    return AuthUserLocalEntity(
      token: token,
      name: fullName,
      email: emailHashed,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      role: role,
      phoneOtpVerified: phoneOtpVerified,
      emailOtpVerified: emailOtpVerified,
      agreedToTerms: agreedToTerms,
      isTruthfully: isTruthfully,
      walletId: walletId,
      stripeAccountId: stripeAccountId,
      stripeCustomerId: stripeCustomerId,
      locationName: location?.name,
      latitude: location?.lat,
      longitude: location?.lng,
    );
  }

    AuthUser copyWith({
    String? id,
    String? fullName,
    String? emailHashed,
    String? token,
    int? role,
    String? phoneNumber,
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
    return AuthUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      emailHashed: emailHashed ?? this.emailHashed,
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
      location: location ?? this.location,
      devices: devices ?? this.devices,
    );
  }
}
