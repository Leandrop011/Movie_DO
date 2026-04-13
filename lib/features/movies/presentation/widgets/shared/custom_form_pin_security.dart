import 'package:flutter/material.dart';

class CustomFormPIN extends StatelessWidget {

  // final double grade;
  final double? width;
  final double? height;
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String initialValue;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomFormPIN({
    super.key, 
    // required this.grade, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false, 
    this.keyboardType = TextInputType.number, 
    this.onChanged, 
    this.onFieldSubmitted, 
    this.validator, 
    this.initialValue = '', 
    this.width, 
    this.height,
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;


    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10)
    );

    // const borderRadius = Radius.circular(15);

    return Container(
      // padding: const EdgeInsets.only(bottom: 0, top: 15),
      width: width ?? size.width * 0.3,//? poco de width porque si coloco infinity se desborda
      height: height ?? size.height * 0.06,
      //! DECORADOR DE LA CAJA 
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0,5)
          )
        ]
      ),

      child: TextFormField(
        maxLength: 4,//? para que solo ingrese maximo 3 caracteres
        // textInputAction: TextInputAction.done,
        onChanged: onChanged,//! EL QUE CAPTURA LO QUE ESCRIBE EL USER
        validator: validator,//! VALIDADOR DE QUE NO INGRESE COSAS INCORRECTAS
        //* como ya es una funcion no es necesario '() => ' solo se coloca la referencia hacia la funcion
        onFieldSubmitted: onFieldSubmitted, //! CUANDO EL USER PULSE EN CHECK EN EL TECLADO SE EJECUTA LA FUNCION
        obscureText: obscureText,//! PARA QUE OCULTE EL TEXTO, Y LO COLOQUE *****
        keyboardType: keyboardType,//! PARA QUE TIPO DE TECLADO MUESTRE CUANDO INGRESE
        // ! PARA EL ESTYLO DEL TEXTO
        style: textTheme.titleMedium?.copyWith(color: colors.onSurface),
        initialValue: initialValue,
        
        decoration: InputDecoration(
          counterText: '', //? oculta el contador que coloca maxlength 
          // floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent)),
          focusedErrorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent)),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}
