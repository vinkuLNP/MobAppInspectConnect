import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ServiceAreaLocalEntity {
  int id;

  String? countryCode;
  String? stateCode;
  String? cityName;

  String? locationType;
  double? latitude;
  double? longitude;

  final inspector = ToOne<InspectorSignUpLocalEntity>();

  ServiceAreaLocalEntity({
    this.id = 0,
    this.countryCode,
    this.stateCode,
    this.cityName,
    this.locationType,
    this.latitude,
    this.longitude,
  });
}
