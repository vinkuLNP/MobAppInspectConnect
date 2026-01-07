import 'package:objectbox/objectbox.dart';
import 'inspector_sign_up_entity.dart';

@Entity()
class IccDocumentLocalEntity {
  int id;

  String serviceCity;
  String documentUrl;
  String expiryDate;

  final inspector = ToOne<InspectorSignUpLocalEntity>();

  IccDocumentLocalEntity({
    this.id = 0,
    required this.serviceCity,
    required this.documentUrl,
    required this.expiryDate,
  });
}
