import 'package:movies_app/features/shared/infrastructure/services/config/security/security_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityValueStorageServiceImpl extends SecurityValueStorageService {

  Future getSharedPreferens() async{
    return await SharedPreferences.getInstance();
  }

  @override
  Future<bool> getValue(String key) async{
    final prefs = await getSharedPreferens();
    
    // ? por si no lo recibimos, cuando inicia la app por primera vez,
    // ? definir un valor por defecto
    return await prefs.getBool(key) ?? false;
  }

  @override
  Future<void> setValue(bool value, String key) async{
    final prefs = await getSharedPreferens();

    await prefs.setBool(key, value);
  }
  
}