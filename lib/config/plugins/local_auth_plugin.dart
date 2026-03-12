
import 'package:local_auth/local_auth.dart';

class LocalAuthPlugin {
  
  // * Instancia del paquete
  static final LocalAuthentication auth = LocalAuthentication();


  // * SABER SI EL DISPOSITIVO TIENE BIOMETRICO 
  static Future<void> availableBiometrics() async{
    final List<BiometricType> availableBiometrics = await auth
    .getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
    }

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!
    }
  }

  // * WRAPPER PARA SABER SI PODEMOS VERIFICAR BIOMETRICOS DIGITALIZADOS
  static Future<bool> canCheckBiometrics() async{
    return await auth.canCheckBiometrics;
  }

  // * WRAPPER PARA SABER SI TIENE EL HARDWARE NECESARIO PARA BIOMETRICOS
  static Future<bool> isDeviceSupported() async{
    return await auth.isDeviceSupported();
  }

  // * METODO QUE SE LANZA AL MOMENTO DE LA AUTENTICACION
  static Future<(bool, String)> authenticate({ bool biometricOnly = false}) async{
    try {
      
      // ? AUTENTICACION
      final bool didAuthenticate = await auth.authenticate(
        // ? mensaje que indica al user
        localizedReason: 'Por favor autenticate para acceder.',
        // ? el biometric only lo recibimos opcional,
        //? por si otros devs quieres acceder a esto pero no tienen acceso al plugin o al provider
        biometricOnly: biometricOnly //* solo permitir el biometrico, nada de pin registrado
      );


      // * MANDAMOS EL RESULTADO DEL DIDaUTHENTICATE
      // * Y SI ES TRUE MANDAMOS UN MENSAJE DE HECHO, PERO SI NO MANDAMOS UN MENSAJE DE ERROR
      return(didAuthenticate, didAuthenticate ? 'Hecho.': 'Cancelado por Usuario.');

    } on LocalAuthException catch (e) {
      // print('Error: $e');
      // ! EXCEPCIONES
      // ? POR SI NO HAY BIOMETRICOS REGISTRADOS
      if(e.code == LocalAuthExceptionCode.noBiometricsEnrolled){
        return(false, 'No hay Biometricos enrolados');
      }
      // ? POR SI POR DEMASIADOS INTENTOS ESTA BLOQUEADO POR UN TIEMPO
      if(e.code == LocalAuthExceptionCode.temporaryLockout){
        return(false, 'Muchos intentos fallidos');
      }
      // ? POR SI EL DISPOSITIVO NO TIENE EL HARDWARE PARA ESOS BIOMETRICOS
      if(e.code == LocalAuthExceptionCode.noBiometricHardware){
        return(false, 'No hay biometricos disponibles');
      }
      // ? POR SI EL USUARIO NO COLOCO LAS CREDENCIALES ANTES
      if(e.code == LocalAuthExceptionCode.noCredentialsSet){
        return(false, 'No hay credenciales configuradas');
      }
      // ? POR SI YA INTENTO DEMASIADOS INTENTOS, Y YA ESTA BLOQUEADO PARA SIEMPRE
      if(e.code == LocalAuthExceptionCode.biometricLockout){
        return(false, 'Se requiere desbloquear el telefono');
      }

      // ? por si no cae en ninguna
      return(false, e.toString());
    }
  }

}