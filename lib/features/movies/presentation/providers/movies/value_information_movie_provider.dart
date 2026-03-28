import 'package:flutter_riverpod/legacy.dart';

//! PROVIDER
final valueInformationMovieProvider = StateNotifierProvider.autoDispose.family<ValueInformationMovieNotifier, ValueInformationMovieState, int>((ref, int value) {
  
  final legthValue = value;

  return ValueInformationMovieNotifier(lengthDescription: legthValue);
});

// ! NOTIFIER
class ValueInformationMovieNotifier extends StateNotifier<ValueInformationMovieState> {

  final int lengthDescription;

  ValueInformationMovieNotifier({required this.lengthDescription}): super(ValueInformationMovieState()){
    if(lengthDescription < 160){
      state = state.copyWith(
        enabled: false,
      );
      return;
    }else if(lengthDescription > 160){
      state = state.copyWith(enabled: true);
      return;
    }

  }


  // * METODO QUE CAMBIA EL VALOR DEL BOOL PARA MOSTRAR MAS INFORMACION, DEPENDIENDO DE LA CANTIDAD DE INFORMACION
  void changeValueInformation( bool valueActive){
    if (_sizeInformation(lengthDescription) == true && valueActive == true) {

      state = state.copyWith(
        active: true,
        linesInformation: 50,
      );

      return;
    }

    state = state.copyWith(linesInformation: 7, active: false);

  }

  // ? METODO QUE DEVUELVE UN BOOL DEPENDIENDO DEL TAMANO DE LA INFORMACION
  bool _sizeInformation(int description){
    if(description > 160){
      return true;
    }

    return false;
  }
  
}

// ! STATE 
class ValueInformationMovieState {
  final bool enabled;
  final bool active;
  final int linesInformation;

  ValueInformationMovieState({
    this.enabled = false, 
    this.active = false, 
    this.linesInformation = 7,
  });

  ValueInformationMovieState copyWith({
    bool? enabled,
    bool? active,
    int? linesInformation,
  }) => ValueInformationMovieState(
      enabled: enabled ?? this.enabled,
      active: active ?? this.active,
      linesInformation: linesInformation ?? this.linesInformation,
  );
  
}
