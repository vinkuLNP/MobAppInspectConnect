import 'package:clean_architecture/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/user_location_entity.dart';

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
