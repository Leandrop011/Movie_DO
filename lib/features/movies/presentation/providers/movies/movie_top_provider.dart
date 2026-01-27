import 'dart:math';

import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ! PARA QUE GENERE UNA PELICULA ALEATORIA ENTRE 0 10 DE EN LA CARTELERA GRANDE
final Random random = Random();

final movieRandom = random.nextInt(10);

final movieTopProvider = Provider<Movie>( 
  (ref){
    final nowPlaying = ref.read(nowPlayingMoviesProvider);
    final movie = nowPlaying[movieRandom];//* Tomamos el primer valor del datasource
    
      return movie;
  }
);