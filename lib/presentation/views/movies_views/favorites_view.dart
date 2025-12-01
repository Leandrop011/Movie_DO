import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:movies_app/presentation/widgets/movies/movies_masonry.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

  @override
  void initState() {
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();//* PARA EMPEZAR EL PROCEDIMIENTO DE INICIALIZACION
    super.initState();//!SIEMPRE COLOCARLO PRIMERO
    
  }



  @override
  Widget build(BuildContext context) {

    final movies = ref.watch(favoriteMoviesProvider);
    final myMovieList = movies.values.toList();//TRANFORMAR A LISTA LAS MOVIES QUE VIENEN COMO MAPA
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme;

    if(myMovieList.isEmpty){
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 100, color: colors.primary,),
              SizedBox(height: 10,),
              Text('Sin peliculas Favoritas', style: style.titleMedium,)
            ],
          ),
        ),
      );
    }

    return Scaffold(

      body: MoviesMasonry(
        movies: myMovieList, 
        loadNextPage: () => ref.read(favoriteMoviesProvider.notifier).loadNextPage(), //* el () => es porque espera una funcion
      )
    );
  }
}