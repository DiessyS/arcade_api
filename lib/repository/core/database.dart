import 'dart:io';

import '../../objectbox.g.dart';

class Database {
  late final Store store;
  late final String local;

  Database({required this.local}) {
    Directory(local).createSync(recursive: true);
    store = Store(getObjectBoxModel(), directory: local);
  }

  close() {
    store.close();
  }
}
