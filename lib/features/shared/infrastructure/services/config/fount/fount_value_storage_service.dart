
abstract class FountValueStorageService {
  Future<void> setValue(String key, bool value);
  Future<bool> getValue(String key);
}