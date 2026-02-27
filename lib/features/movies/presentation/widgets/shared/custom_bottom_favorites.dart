import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/presentation/providers/storage/index.dart';

class CustomButton extends ConsumerStatefulWidget {
  final Movie movie;
  final bool isDarck;
  final IconData iconActive;
  final IconData iconNotActive;
  final VoidCallback onPressed;//? recibimos la funcion onpressed, usamos voidCallBack
  

  const CustomButton({
    super.key, 
    required this.movie, 
    required this.isDarck, 
    required this.iconActive, 
    required this.onPressed, 
    required this.iconNotActive
  });

  @override
  ConsumerState<CustomButton> createState() => _CustomBottomFavoritesState();
}

class _CustomBottomFavoritesState extends ConsumerState<CustomButton> {
  
  
  
  //* CONSTRUCCION DEL SNACKBAR SI AGREGA O QUITA DE FAVORITOS


  @override
  Widget build(BuildContext context) {
    final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(widget.movie.id));
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
          child: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite == true ?
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.iconActive, color: Colors.red,),
                // SizedBox(width: 5,),
                // Text('Eliminar', style: TextStyle(color: Colors.white, fontSize: size.width * 0.03),),
              ],
            )
            :
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.iconNotActive, color: Colors.white,),
                // SizedBox(width: 5,),
                // Text('Agregar', style: TextStyle(color: Colors.white, fontSize: size.width * 0.03),),
              ],
            ),
            error: (_, _) => throw Exception("Error al cargar el estado de favoritos"), 
            loading: () => Center(
              child: SizedBox(
                width: 10,
                height: 10,
                child: const CircularProgressIndicator(strokeWidth: 2,)
              )
            )
          ), 
        ),
      ),
    );
  }
}
