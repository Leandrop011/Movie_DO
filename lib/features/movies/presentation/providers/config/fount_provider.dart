
import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/shared/infrastructure/services/fount_value_storage_service.dart';
import 'package:movies_app/features/shared/infrastructure/services/fount_value_storage_service_impl.dart';

// ! PROVIDER
final isdarckProvider = StateNotifierProvider.autoDispose<FountNotifier, FountState>((ref) {
  
  final fountValueStorageService = FountValueStorageServiceImpl();
  
  return FountNotifier(fountValueStorageService: fountValueStorageService);
});

// ! NOTIFIER
class FountNotifier extends StateNotifier<FountState> {
  final FountValueStorageService fountValueStorageService;
  FountNotifier({required this.fountValueStorageService}): 
  super(FountState()){
    initialFount();//* inicializamos el fount apenes inicie el uso del provider
  }
  
  // * inicializamos el valor del fount, obtenemos el valor que ya fue guardado con el set
  // * y cambaimos el state de la app, para que se vean los cambios
  void initialFount() async{
    //* obtenemos el valor guardado
    final value = await fountValueStorageService.getValue('value');
    // * cambiamos el state con ese valor obtenido para que se vea visualmente
    state = state.copyWith(
      fount: value
    );
   
  }
  // *
  void setFount(bool value) async{
    // * establecemos el valor( lo guardamos en el dispositivo)
    await fountValueStorageService.setValue('value', value);
    
    // * cambiamos el state
    state = state.copyWith(
      fount: value
    );
  }
}

// ! STATE
class FountState{
  final bool fount;

  FountState( {this.fount = true} );

  FountState copyWith({
     bool? fount,
  })  => FountState(
    fount: fount ?? this.fount
  );
}