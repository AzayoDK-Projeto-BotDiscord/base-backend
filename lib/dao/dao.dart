abstract class DAO<T> {
  Future<bool> create(T value);
  Future<T> findeOne(int id);
  Future<List<T>> findeAll();
  Future<bool> update(T value);
  Future<bool> delete(int id);
}
