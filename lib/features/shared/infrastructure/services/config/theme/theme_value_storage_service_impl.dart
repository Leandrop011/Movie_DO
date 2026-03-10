import 'package:movies_app/features/shared/infrastructure/services/config/theme/theme_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeValueStorageServiceImpl extends ThemeValueStorageService {

  Future getSharedPrefs() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Future<int> getValue(String key) async{
    // ! ES IMPORTANTE ESPERAR LA INSTANCIA
    final prefs = await getSharedPrefs();

    return await prefs.getInt(key) ?? 0;
  }

  @override
  Future<void> setValue(int value, String key) async{
    final prefs = await getSharedPrefs();

    await prefs.setInt(key, value);
  }
  
}