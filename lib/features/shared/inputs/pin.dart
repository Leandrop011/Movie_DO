
// // * ENUMERACION
// import 'package:formz/formz.dart';

// enum PinError{empty, valueError, format}

// // * CLASE
// class PinInput extends FormzInput<int, PinError>{
  
//   // * Call super.pure to represent an unmodified form input.
//   const PinInput.pure(int i) : super.pure(0);

//   // * Call super.dirty to represent a modified form input.
//   const PinInput.dirty(super.value) : super.dirty();

//   // * EXPRESION REGULAR DE VALIDACION DE FORMATO, SOLO NUMEROS Y 4 DIGITOS
//   static final RegExp _regExp = RegExp(r'^\d{4}$');

//   // * OBTENEMOS EL ERROR SI EXISTE
//   String? get errorMessage{
//     if(isValid|| isPure) return null;

//     // ? SI EL DISPLAY ERROR TIENE UN ERROR PUES DEVUELVE EL STRING
//     if(displayError == PinError.empty) return 'Requerido';
//     if(displayError == PinError.format) return 'Mín. 4 dígitos';
//     if(displayError == PinError.valueError) return 'Valor inválido';


//     return null;
//   }
  
//   // * FUNCION VALIDATOR QUE LLENA EL DISPLAY ERROR SI EXIST UN ERROR
//   @override
//   PinError? validator(int value) {
//     if(value.toString().isEmpty || value.toString().trim().isEmpty) return PinError.empty;
//     if(value < 0 ) return PinError.valueError;
//     if( !_regExp.hasMatch(value.toString().trim())) return PinError.format;

//     return null;
//   }

  

// }