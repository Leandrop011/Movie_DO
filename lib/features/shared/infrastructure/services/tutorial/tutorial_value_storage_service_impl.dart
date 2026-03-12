import 'package:movies_app/features/shared/infrastructure/services/tutorial/tutorial_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialValueStorageServiceImpl extends TutorialValueStorageService {
  // * INSTANCIA DE SHARED PREFERENCES
  Future<SharedPreferences> getInstance() async{
    return await SharedPreferences.getInstance();
  }

  @override
  Future<bool> getValueTutotrial(String key) async{
    final prefs = await getInstance();

    return prefs.getBool(key) ?? false;

  }

  @override
  Future<void> setValueTutorial(bool value, String key) async{
    final prefs = await getInstance();

    await prefs.setBool(key, value);
  }
  
}