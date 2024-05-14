import 'package:arcade_repository/arcade_repository.dart';

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
