import 'dart:io';

import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AppLocalDatabase {
  static Store? store;

void saveInspector(InspectorSignUpLocalEntity entity) {
  store!.box<InspectorSignUpLocalEntity>().put(entity);
}


static Future<AppLocalDatabase> create() async {

  final Directory docsDir = await getApplicationDocumentsDirectory();
final dbDir = Directory(p.join(docsDir.path, 'objectbox'));
  if (!dbDir.existsSync()) {
    dbDir.createSync(recursive: true);
  }
store = await openStore(directory: p.join(docsDir.path, 'objectbox'));

  return AppLocalDatabase();
}

  int? insert<T>(T object) {
    final Box<T>? box = store?.box<T>();
    return box?.put(object);
  }

  Future<List<T>?> getAll<T>() async {
    final Box<T>? box = store?.box<T>();
    return box?.getAll();
  }
    void clear<T>() {
    final Box<T>? box = store?.box<T>();
    box?.removeAll();
  }


  void clearAll<T>() {
    final box = store!.box<T>();
    box.removeAll();
  }
}


