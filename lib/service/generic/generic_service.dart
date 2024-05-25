import '../../repository/core/repository.dart';

class GenericService<T> {
  final Repository<T> repository;

  GenericService(this.repository);

  T? getById(int id) {
    return repository.get(id);
  }

  List<T> getAll() {
    return repository.getAll();
  }

  int save(T entity) {
    return repository.add(entity);
  }

  int update(T entity) {
    return repository.update(entity);
  }

  void delete(T entity) {
    repository.remove((entity as dynamic).id);
  }
}
