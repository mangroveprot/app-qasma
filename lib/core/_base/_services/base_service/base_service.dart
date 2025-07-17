import '../../_repository/base_repository/abstract_repositories.dart';

abstract class BaseService<T> {
  final AbstractRepository<T> repository;

  BaseService(this.repository);

  Future<List<T>> getAll() => repository.getAllItems();

  Future<T?> getById(dynamic id) => repository.getItemById(id);

  Future<void> save(T item) => repository.saveItem(item);

  Future<void> delete(dynamic id) => repository.deleteItemById(id);

  Future<void> sync() => repository.syncItems();

  Future<List<T>> search(String keyword, List<String> fields) =>
      repository.search(keyword, fields);

  Future<int> count() => repository.count();
}
