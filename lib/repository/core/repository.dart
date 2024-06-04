import 'package:objectbox/objectbox.dart';

import 'database.dart';

class Repository<T> {
  late final Box<T> box;

  Repository(Database database) {
    box = Box<T>(database.store);
  }

  int add(T item) {
    return box.put(item, mode: PutMode.insert);
  }

  int update(T item) {
    return box.put(item, mode: PutMode.update);
  }

  T? get(int id) {
    return box.get(id);
  }

  List<T> getAll() {
    return box.getAll();
  }

  List<T> getByQuery(Query<T> query) {
    return query.find();
  }

  remove(int id) {
    box.remove(id);
  }
}
