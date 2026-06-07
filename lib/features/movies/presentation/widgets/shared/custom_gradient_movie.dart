//* COMO NECESITAMOS ALGUNOS GRADIENTES SIMILARES, HACEMOS UN METODO DE CUSTOMGRADIENT
//* PARA NO REPETIR CODIGO
import 'package:flutter/material.dart';

class CustomGradient extends StatelessWidget {
  
  final Alignment begin;
  final Alignment? end;//*ES OPCIONAL
  final List<double> stops;
  final List<Color> colors;

  const CustomGradient({
    super.key, 
    required this.begin, 
    this.end, 
    required this.stops,
    required this.colors, 
  });

  //begin  
  //end
  //stops []
  //colors []

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,//* inicio
                end: end ?? Alignment.center,//* final
                stops: stops,
                colors: colors
              )
            )
      ),
    );
  }
}