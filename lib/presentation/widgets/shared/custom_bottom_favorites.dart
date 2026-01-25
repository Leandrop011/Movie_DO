import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:movies_app/presentation/providers/storage/is_favorite_movie_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:audioplayers/audioplayers.dart';

class CustomBottomFavorites extends ConsumerStatefulWidget {
  final Movie movie;
  final bool isDarck;

  const CustomBottomFavorites({super.key, required this.movie, required this.isDarck});

  @override
  ConsumerState<CustomBottomFavorites> createState() => _CustomBottomFavoritesState();
}

class _CustomBottomFavoritesState extends ConsumerState<CustomBottomFavorites> {
  
  //! PARA EL USO DE SONIDSO ES NECESARIO EL PLUGIN AUDIOPLAYERS
  //! SE REQUIERE UN STATEFUL O CONSUMERFUL, ADEMAS DE MODIFICAR EL ANDROIDMANIFEST
  //! UNA FUNCION FUTURA Y TERMINAR EL VALOR CON EL DISPOSE 
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> reproducirSonido() async{
    await _audioPlayer.setVolume(0.2);//* REGULAR EL VOLUMEN 1 MAXIMO
    await _audioPlayer.play(AssetSource('sounds/mixkit-select-click-1109.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  
  //* CONSTRUCCION DEL SNACKBAR SI AGREGA O QUITA DE FAVORITOS
  void _snackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).clearSnackBars();//* Cierra el anterior
    final snackBar = SnackBar(//* crea el nuevo
      content: Text(message),
      behavior: SnackBarBehavior.floating,//* efecto de estar flotando en la pantalla
      backgroundColor: widget.isDarck?
      Colors.white70
      :
      Colors.black87,
      // action: SnackBarAction(
      //   label: 'Ok', 
      //   onPressed: (){}
      // ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10)
      ),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);//* muestra el nuevo
  }

  @override
  Widget build(BuildContext context) {
    final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(widget.movie.id));
    final size = MediaQuery.of(context).size;
    final valueFavorite = isFavoriteFuture.value ?? false;
    //final colors = Theme.of(context).colorScheme;    
    
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 15, bottom: 5),
      child: InkWell(
        onTap: () async{

          //! ACTUALIZAR LA DATABASE
          await ref.read(favoriteMoviesProvider.notifier).toggleFavoriteMovie(widget.movie);
          ref.invalidate(isFavoriteMovieProvider(widget.movie.id));
          final isFav = isFavoriteFuture.value ?? false;//* Obtenemos el valor
          
          if(isFav == true){//* Significa que es un favorito, si lo pulsa de debe mostrar mensaje de se quito
            // ignore: use_build_context_synchronously
            _snackBar(context, 'Se quito de tus favoritos');
          }else{
            // ignore: use_build_context_synchronously
            _snackBar(context, 'Se agrego a tus favoritos');
          }

          reproducirSonido();
        },
        child: Container(
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: valueFavorite ? 
            const Color.fromARGB(255, 105, 106, 107)
            :
            Colors.transparent,
            border: Border.all(
              width: 3, 
              color: Colors.white
            )
          ),
          width: size.width * 0.3,
          height: size.height * 0.065,
          child: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite == true ?
            Icon(Icons.check, size: 29,)
            :
            Icon(Icons.add, size: 29,), 
            error: (_, __) => throw Exception("Error al cargar el estado de favoritos"), 
            loading: () => Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: Colors.white, 
                size: 20
              ),
            )
          ),
        ),
      ),
    );
  }
}