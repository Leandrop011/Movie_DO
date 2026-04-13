// import 'package:flutter_riverpod/legacy.dart';
// import 'package:formz/formz.dart';
// import 'package:movies_app/features/features.dart';
// import 'package:movies_app/features/shared/inputs/pin.dart';

// // ! PROVIDER
// final pinFormProvider = StateNotifierProvider.autoDispose<PinFormNotifier, PinFormState>((ref) {
  
//   final SecurityValuePinStorageerviceImpl securityValuePinStorageerviceImpl = SecurityValuePinStorageerviceImpl();

//   return PinFormNotifier(securityValuePinStorageService: securityValuePinStorageerviceImpl);
// });

// const String valueKeyPinActive = 'pin_security_active';
// const String valueKeyPin = 'pin_security';

// // ! STATE NOTIFIER
// class PinFormNotifier extends StateNotifier<PinFormState> {

//   final SecurityValuePinStorageService securityValuePinStorageService;

//   PinFormNotifier({
//     required this.securityValuePinStorageService
//   }): super(PinFormState()){
//     // ! CADA QUE SE NECESITE ESTE PROVIDER SE EJECUTARA ESTA FUNCION
//     getValuePin();
//     getValueActivePin();
//   }
  
//   // * METODO QUE VERIFICAMOS EL INGRESO, SI POSEE UN ERROR, PUES LO EMITIRA
//   void onInputChanged(int pin){
//     state = state.copyWith(
//       pinInput: PinInput.dirty(pin),
//       isFormValid: Formz.validate([
//         PinInput.dirty(pin),
//       ])
//     );
//   }

//   void _touchInput(){
//     state = state.copyWith(
//       isFormValid: Formz.validate([
//         PinInput.dirty(state.pinInput.value),
//       ])
//     );
//   }

//   // * METODO QUE ENVIA EL FORMULARIO
//   void onFormSumbit() async{
    
//     // ? METODO QUE TOCA EL CAMPO Y VERIFICA SI ESTA CORRECTO
//     _touchInput();
    
//     // ? SI NO ES VALIDO PUES RETORNA FALSE
//     if(state.isFormValid == false) {
//       state = state.copyWith(
//         isFormValid: false,
//         isPinActive: false,
//       );
//     }

//     // ? SI TODO1 ES CORRECTO PUES GUARDA EL VALOR // ! DEL INPUT EN MEMORIA LOCAL
//     setValuePin(state.pinInput.value);


//     state = state.copyWith(
//       isFormValid: true,
//       isPinEnabled: false,
//     );

//   }

//   // * METODO QUE GUARDA EN MEMORIA EL PIN
//   void setValuePin(int value) async{
//     await securityValuePinStorageService.setValue(valueKeyPin, value);

//     state = state.copyWith(
//       pinInput: PinInput.dirty(value),
//     );
//   }

//   // * METODO QUE OBTIENE EL VALOR DEL PIN EN MEMORIA
//   Future<(int, bool)> getValuePin() async{
//     final pin = await securityValuePinStorageService.getValue(valueKeyPin);

//     // ! NO REALIZAR ESTO PORQUE ESTA FUNCION SE EJECUTA CADA QUE SE NECESITA EL PROVIDER
//     // ! OSEA APENAS ENTRAR NOS MOSTRARA UN ERROR
//     // state = state.copyWith(
//     //   pinInput: PinInput.dirty(pin),
//     // );

//     // * ESTO RETORNARA UN BOOL FALSE SI EL PIN GUARDADO EN MEMORIA ESTA VACIO
//     // * SINO RETORNA TRUE, PARA DECIDIR SI MOSTRAR UN CAMPO DE INGRESO O DE ACTIVACION
//     if(pin.toString().trim().isEmpty || pin == -1){

//       state = state.copyWith(
//         isPinActive: false,
//       );

//       return (-1, false); 
//     }

//     state = state.copyWith(
//       isPinActive: true,
//     );

//     return (0, true);
//   }

//   // * METODO PARA MANEGAR UN TOGGLE Y PERMITIRLE AL USER
//   // * HABILITAR EL PIN(SI EXISTE EL PIN PARA ESE PUNTO)
//   void toggle( bool value ) async{

//     await securityValuePinStorageService.setValuActivePin(valueKeyPinActive, value);

//     state = state.copyWith(
//       isPinEnabled: value,
//     );
//   }

//   // * METODO QUE VERIFICA SI EL PIN QUE REGISTRA EL USER ES EL MISMO CON EL QUE ESTA 
//   // * GUARDADOII LOCALMENTE
//   Future<bool> verificationPin(int value) async{

//     final valuePinSave = await getValuePin();

//     if(value == valuePinSave.$1){
//       state = state.copyWith(
//         isFormValid: true,
//       );
//       return true;
//     }

//     return false;
//   }

//   // * METODO QUE ELIMINA EL PIN GUARDADO LOCALMENTE
//   void deletePin() async{
//     await securityValuePinStorageService.setValue(valueKeyPin, -1);
//     state = state.copyWith(
//       isPinActive: false,
//     );
//   }
  
//   Future<bool> getValueActivePin() async{
//     final valueActive = await securityValuePinStorageService.getValuActivePin(valueKeyPinActive);
//     if(valueActive == true){

//       state = state.copyWith(
//         isPinEnabled: valueActive,
//       );
//       return true;
//     }

//     return false;
//   }

//   void setValueActivePin(bool value) async{
//     await securityValuePinStorageService.setValuActivePin(valueKeyPinActive, value);

//     state = state.copyWith(isPinEnabled: true);
//   }



// }

// // ! STATE
// class PinFormState {
  
//   final bool     isFormValid;   // * PARA VERIFICAR SI EL FORM ES VALIDO
//   final bool     isFormPosted;  // * SI EL FORMULARIO YA SE POSTEO
//   final PinInput pinInput;      // * VALOR DEL INPUT
//   final bool     isPinActive;   // * SABER SI EL PIN ESTA ACTIVO O EXISTE
//   final bool     isPinEnabled;  // * SABER SI EL PIN ESTA HABILITADO A USARSE(SI EXISTE)

//   PinFormState({
//     this.isFormValid  = false, 
//     this.isFormPosted = false, 
//     this.pinInput     = const PinInput.pure(0), 
//     this.isPinActive  = false, 
//     this.isPinEnabled = false, 
//   });
  

//   PinFormState copyWith({
//     bool?     isFormValid,
//     bool?     isFormPosted,
//     PinInput? pinInput,
//     bool?     isPinActive,
//     bool?     isPinEnabled,
//   }) => PinFormState(
//       isFormValid:  isFormValid ?? this.isFormValid,
//       isFormPosted: isFormPosted ?? this.isFormPosted,
//       pinInput:     pinInput ?? this.pinInput,
//       isPinActive:  isPinActive ?? this.isPinActive,
//       isPinEnabled: isPinEnabled ?? this.isPinEnabled,
//   );
  
// }


// // * PROVIDER QUE GUARDA DE FORMA TEMPORAL EL PIN 
// // * QUE INGRESA EL USER 

// final valuePinProvider = StateProvider.autoDispose<int>((ref) {
//   return 0;
// });