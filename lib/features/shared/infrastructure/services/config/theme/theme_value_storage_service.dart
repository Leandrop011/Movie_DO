
abstract class ThemeValueStorageService {
  Future<void> setValue(int value, String key);
  Future<int> getValue(String key);
}