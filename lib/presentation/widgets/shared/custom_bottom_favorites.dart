import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:movies_app/presentation/providers/storage/is_favorite_movie_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomBottomFavorites extends ConsumerWidget {
  final Movie movie;
  const CustomBottomFavorites({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(movie.id));
    final size = MediaQuery.of(context).size;

    //final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 15, bottom: 5),
      child: InkWell(
        onTap: () async{
          //! PARTE DEL SNACKBAR PARA QUE ACTUALICE RAPIDO SI EL USUARIO QUITA Y PONE RAPIDO
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();

          //! ACTUALIZAR LA DATABASE
          await ref.read(favoriteMoviesProvider.notifier).toggleFavoriteMovie(movie);
          ref.invalidate(isFavoriteMovieProvider(movie.id));
        
          final isFav = isFavoriteFuture.value ?? false;//* Obtenemos el valor
          if(isFav == true){//* Significa que es un favorito, si lo pulsa de debe mostrar mensaje de se quito
            messenger.showSnackBar(
              SnackBar(
                content: Text('Se quito de tus favoritos'),
                duration: Duration(seconds: 1),
              )
            );
          }else{
            messenger.showSnackBar(
              SnackBar(
               content: Text('Se agrego a tus favoritos'),
               duration: Duration(seconds: 1),
              )
            );
          }
        },
        child: ZoomIn(
          child: Container(
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
              border: Border.all(
                width: 2, 
                color: Colors.white
              )
            ),
            width: size.width * 0.28,
            height: size.height * 0.05,
            child: isFavoriteFuture.when(
              data: (isFavorite) => isFavorite == true ?
              Icon(Icons.check, color: const Color.fromARGB(255, 60, 193, 182), size: 25,)
              :
              Icon(Icons.add), 
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
      ),
    );
  }
}