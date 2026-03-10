
abstract class SecurityValueStorageService {
  Future<void> setValue(bool value, String key);
  Future<bool> getValue(String key);
}