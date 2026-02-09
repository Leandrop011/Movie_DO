import 'package:movies_app/features/shared/infrastructure/services/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ! SIEMPRE SON METODOS SET PAR AGUARDARLO MIENTRAS LA APP CORRE, PARA ESTABLECER VALOR
// !  Y GET PARA OBTENERLO APENAS INICIAR LA APP, PARA USAR EL SHARED_PREFERENCES
class FountValueStorageServiceImpl extends FountValueStorageService {
  Future getSharedPrefs() async{
    return await SharedPreferences.getInstance(); 
  }
  
  @override
  Future<void> setValue(String key, bool value) async{
    final prefs = await getSharedPrefs();

    await prefs.setBool(key, value);

  }
  
  @override
  Future<bool> getValue(String key) async{
    final prefs = await getSharedPrefs();

    // * el provider es el que me dara el valor
    return await prefs.getBool(key) ?? true;
  }
  
}
