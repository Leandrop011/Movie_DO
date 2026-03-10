import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/shared/infrastructure/services/config/security/security_value_storage_service.dart';
import 'package:movies_app/features/shared/infrastructure/services/config/security/security_value_storage_service_impl.dart';

// ! PROVIDER
final securityProvider = StateNotifierProvider.autoDispose<SecurityNotifier, SecurityState>((ref) {
  
  // ? NECESITAMOS UNA INSTANCIA DE LA CLASE
  final securityValueStorageService = SecurityValueStorageServiceImpl();
  
  return SecurityNotifier( securityValueStorageService: securityValueStorageService );
});
// ! NOTIFIER
class SecurityNotifier extends StateNotifier<SecurityState> {

  final SecurityValueStorageService securityValueStorageService;

  SecurityNotifier({required this.securityValueStorageService}): super(SecurityState()){
    getSecurity();
  }
  
  void getSecurity() async{
    final securityValue = await securityValueStorageService.getValue('security');


    state = state.copyWith(
      activeSecurity: securityValue
    );
  }

  void setSecurity(bool value){

    securityValueStorageService.setValue(value, 'security');

    state = state.copyWith(
      activeSecurity: value
    );
  }
  
}

// ! STATE
class SecurityState {
  final bool activeSecurity;

  SecurityState({
    this.activeSecurity = false
  });

  SecurityState copyWith({
    bool? activeSecurity,
  }) => SecurityState(
      activeSecurity: activeSecurity ?? this.activeSecurity,
  );
  
}
