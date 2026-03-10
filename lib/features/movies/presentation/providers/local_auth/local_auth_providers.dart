import 'package:movies_app/config/plugins/local_auth_plugin.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// ! PARA SABER SI EXISTEN O TIENEN REGISTRADO BIOMETRICOS EN EL DISPOSITIVO O EL DEVICE ES CAPAZ POR LA PARTE DEL HARDWARE
final existBiometricProvider = FutureProvider<bool>((ref) async {
  if( await LocalAuthPlugin.canCheckBiometrics() && await LocalAuthPlugin.isDeviceSupported() ){
    return true;
  }

  return false;
});

// ? distintos status de authentication
enum LocalAuthStatus{authenticated, notAuthenticated, authenticating}

// ! PROVIDER
final localAuthProvider = StateNotifierProvider.autoDispose<LocalAuthNotifier, LocalAuthState>((ref) {
  return LocalAuthNotifier();
});

// ! NOTIFIER
class LocalAuthNotifier extends StateNotifier<LocalAuthState> {
  LocalAuthNotifier(): super(LocalAuthState());
  
  Future<(bool, String)> authenticateUser() async{
    // ? DESESTRUCTURAR EL RRECORD
    final (didAuthenticate, message) = await LocalAuthPlugin.authenticate();

    state = state.copyWith(
      didAuthenticate: didAuthenticate,
      status: didAuthenticate ? LocalAuthStatus.authenticated : LocalAuthStatus.notAuthenticated,
      message: message,
    );


    return(didAuthenticate, message);
  }

}

// ! STATE
class LocalAuthState {
  final bool didAuthenticate;
  final LocalAuthStatus status;
  final String message;

  LocalAuthState({
    this.didAuthenticate = false, 
    this.status = LocalAuthStatus.notAuthenticated, 
    this.message = '',
  });

  LocalAuthState copyWith({
    bool? didAuthenticate,
    LocalAuthStatus? status,
    String? message,
  }) => LocalAuthState(
      didAuthenticate: didAuthenticate ?? this.didAuthenticate,
      status: status ?? this.status,
      message: message ?? this.message,
  );
  
}
