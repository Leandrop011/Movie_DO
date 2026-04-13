import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:movies_app/features/movies/presentation/providers/providers.dart';

class CustomButtonAuthenticated extends ConsumerWidget {

  final double width;
  final double height;
  final String text;
  final IconData icon;
  final TextTheme textTheme;
  final VoidCallback onPressed;
  final Size size;
  final ColorScheme colors;

  const CustomButtonAuthenticated({
    super.key, 
    required this.width, 
    required this.height, 
    required this.text, 
    required this.icon, 
    required this.textTheme, 
    required this.onPressed, 
    required this.size, required this.colors
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // final fount = ref.watch(isdarckProvider).fount;

    return GestureDetector(
      onTap: () => onPressed(), // * CON () PORQUE REQUERIMOS LA FUNCION DE INMEDIATO
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.primaryFixedDim,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textTheme.bodySmall?.copyWith(fontSize: size.width * 0.05),
            ),
            const SizedBox(width: 5,),
            Icon(icon, size: size.width * 0.07,),
          ],
        ),
      ),
    );
  }
}