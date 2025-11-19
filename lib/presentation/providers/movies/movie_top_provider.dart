import 'dart:math';

import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Random random = Random();

final movieRandom = random.nextInt(10);

final movieTopProvider = Provider<Movie>( 
  (ref){
    final nowPlaying = ref.read(nowPlayingMoviesProvider);
    final movie = nowPlaying[movieRandom];//* Tomamos el primer valor del datasource
    
      return movie;
  }
);