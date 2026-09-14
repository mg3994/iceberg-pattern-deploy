abstract interface class CacheStore<T> {
  Future<List<T>> readAll();

  Future<void> replaceAll(List<T> values);
}
