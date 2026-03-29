import 'package:movies_app/features/shared/infrastructure/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieLastValueStorageServiceImpl extends MovieLastValueStorageService{

  Future <SharedPreferences> getInstance() async{
    return await SharedPreferences.getInstance();
  }

  @override
  Future<String> getValue(String key) async {

    final prefs = await getInstance();


    return prefs.getString(key) ?? '';
  }

  // * TENER CUIDADO CON EL ORDEN DE LOS ARGUMENTO SY COMO LOS RECIBIMOS, SEGUIR LA DOCUMENTACION
  @override
  Future<void> setValue(String key, String movieId) async{

    final prefs = await getInstance();

    await prefs.setString(key, movieId);

  }
  
}