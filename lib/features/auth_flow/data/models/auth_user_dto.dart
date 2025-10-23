import 'package:clean_architecture/features/auth_flow/data/models/device_dto.dart';
import 'package:clean_architecture/features/auth_flow/data/models/location_dto.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/auth_user.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:clean_architecture/features/auth_flow/domain/entities/user_location_entity.dart';

class AuthUserDto {
  final String id;
  final int? role;
  final String emailHashed;
  final String name;
  final int? status;
  final String? phoneNumber;
  final String? countryCode;
  final bool? phoneOtpVerified;
  final bool? emailOtpVerified;
  final bool? agreedToTerms;
  final bool? isTruthfully;
  final String? walletId;
  final String? stripeAccountId;
  final String? stripeCustomerId;
  final String authToken;
  final LocationDto location;
  final List<DeviceDto> devices;

  AuthUserDto({
    required this.id,
    required this.emailHashed,
    required this.name,
    required this.authToken,
    required this.location,
    required this.devices,
    this.role,
    this.status,
    this.phoneNumber,
    this.countryCode,
    this.phoneOtpVerified,
    this.emailOtpVerified,
    this.agreedToTerms,
    this.isTruthfully,
    this.walletId,
    this.stripeAccountId,
    this.stripeCustomerId,
  });

  factory AuthUserDto.fromBody(Map<String, dynamic> b) => AuthUserDto(
        id: b['_id']?.toString() ?? '',
        role: b['role'] as int?,
        emailHashed: b['email'] as String? ?? '',
        name: b['name'] as String? ?? '',
        status: b['status'] as int?,
        phoneNumber: b['phoneNumber'] as String?,
        countryCode: b['countryCode'] as String?,
        phoneOtpVerified: b['phoneOtpVerified'] as bool?,
        emailOtpVerified: b['emailOtpVerified'] as bool?,
        agreedToTerms: b['agreedToTerms'] as bool?,
        isTruthfully: b['isTruthfully'] as bool?,
        walletId: b['walletId'] as String?,
        stripeAccountId: b['stripeAccountId'] as String?,
        stripeCustomerId: b['stripeCustomerId'] as String?,
        authToken: b['authToken'] as String? ?? '',
        location: LocationDto.fromJson(b['location'] as Map<String, dynamic>?),
        devices: (b['devices'] is List)
            ? (b['devices'] as List)
                .whereType<Map<String, dynamic>>()
                .map(DeviceDto.fromJson)
                .toList()
            : const [],
      );

  AuthUser toEntity() => AuthUser(
        id: id,
        fullName: name,
        emailHashed: emailHashed,
        token: authToken,
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
        location: (location.coordinates?.length == 2)
            ? UserLocation(
                name: location.locationName,
                lat: location.coordinates![0],
                lng: location.coordinates![1],
              )
            : null,
        devices: devices
            .map((d) => UserDevice(token: d.deviceToken, type: d.deviceType))
            .toList(),
      );
}
