
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>(
  (ref){
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
 
    if (nowPlayingMovies.isEmpty) {
      return [];
    }else{
      return nowPlayingMovies.sublist(0, 8);
    }

  } 
);

