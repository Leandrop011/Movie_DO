import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';

class CustomButton extends ConsumerStatefulWidget {
  final Movie movie;
  final bool isDarck;
  final IconData iconActive;
  final IconData iconNotActive;
  final VoidCallback onPressed;//? recibimos la funcion onpressed, usamos voidCallBack
  final Widget child;

  const CustomButton({
    super.key, 
    required this.movie, 
    required this.isDarck, 
    required this.iconActive, 
    required this.onPressed, 
    required this.iconNotActive, 
    required this.child
  });

  @override
  ConsumerState<CustomButton> createState() => _CustomBottomFavoritesState();
}

class _CustomBottomFavoritesState extends ConsumerState<CustomButton> {

  @override
  Widget build(BuildContext context) {
    // final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(widget.movie.id));
    final size = MediaQuery.of(context).size;    
    
    return Padding(
      padding: const EdgeInsetsGeometry.only(top: 15, bottom: 5, right: 10),
      child: SizedBox(
        height: size.height * 0.08,
        width: size.width * 0.235,
        child: FilledButton(
          // * Estilo del botoeN
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10)
            ),
            backgroundColor: Colors.black54
          ),

          onPressed: widget.onPressed,

          // ! INCLUSO EL BOTON DE COMPARTIR NO CARGARA HASTA QUE HAYA CARGADO SI ESTA O NO EN LA BASE 
          // ! DE DATOS LOCAL GUARDADA
          child: widget.child
        ),
      ),
    );
  }
}

