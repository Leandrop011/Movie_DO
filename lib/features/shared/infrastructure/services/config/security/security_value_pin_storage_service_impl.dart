// import 'package:movies_app/features/shared/infrastructure/services/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SecurityValuePinStorageerviceImpl extends SecurityValuePinStorageService {

//   // * INSTANCIA
//   Future<SharedPreferences> _getInstanceSharedPreferences() async{
//     return await SharedPreferences.getInstance();
//   }

//   // * GUARDAR Y OBTENER PIN
//   @override
//   Future<int> getValue(String key) async {
//     final prefs = await _getInstanceSharedPreferences();

//     return prefs.getInt(key) ?? -1;
//   }

//   @override
//   Future<void> setValue(String key, int pin) async {
//     final prefs = await _getInstanceSharedPreferences();

//     await prefs.setInt(key, pin);
//   }
  
//   // * GUARDAR Y OBTENER SI EL PIN ESTA ACTIVO 
//   @override
//   Future<bool> getValuActivePin(String key) async{
//     final prefs = await _getInstanceSharedPreferences();

//     return prefs.getBool(key) ?? false;
//   }
  
//   @override
//   Future<void> setValuActivePin(String key, bool active) async{
//     final prefs = await _getInstanceSharedPreferences();

//     await prefs.setBool(key, active);

//   }
  
// }