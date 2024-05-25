import 'package:objectbox/objectbox.dart';

import 'database.dart';

class Repository<T> {
  late Box<T> _box;

  Repository(Database database) {
    _box = Box<T>(database.store);
  }

  int add(T item) {
    return _box.put(item, mode: PutMode.insert);
  }

  int update(T item) {
    return _box.put(item, mode: PutMode.update);
  }

  T? get(int id) {
    return _box.get(id);
  }

  List<T> getAll() {
    return _box.getAll();
  }

  List<T> getByQuery(Query<T> query) {
    return query.find();
  }

  remove(int id) {
    _box.remove(id);
  }
}
