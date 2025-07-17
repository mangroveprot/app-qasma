abstract class AbstractRepository<T> {
  Future<T?> getItemById(dynamic id);
  Future<List<T>> getAllItems();
  Future<void> saveItem(T item);
  Future<void> saveAllItems(List<T> items);
  Future<void> deleteItemById(dynamic id);
  Future<void> syncItems();
  Future<List<T>> search(String keyword, List<String> fields);
  Future<int> count();
}
