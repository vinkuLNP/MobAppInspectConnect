import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class UserDocumentEntity {
  int id = 0;
  String? documentUrl;
  String? fileName;

  final inspector = ToOne<InspectorSignUpLocalEntity>();

  UserDocumentEntity({this.id = 0, this.documentUrl, this.fileName});

  Map<String, dynamic> toJson() => {
    'documentUrl': documentUrl,
    'fileName': fileName,
  };
}
