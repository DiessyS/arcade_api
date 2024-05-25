import '../../repository/core/database.dart';

class DatabaseService {
  late Database database;
  late String localPath;

  DatabaseService({required this.localPath}) {
    database = Database(local: localPath);
  }

  close() {
    database.close();
  }
}
