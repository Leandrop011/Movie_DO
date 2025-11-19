
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/providers.dart';

//todo, para manegar el numero de peliculas que quiero mostrar
//todo, solo mostrara 6 peliculas en el carrucel de peliculas
final moviesSlideshowProvider = Provider<List<Movie>>(
  (ref){
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
 
    if (nowPlayingMovies.isEmpty) {
      return [];
    }else{
      return nowPlayingMovies.sublist(0, 6);
    }

  } 
);