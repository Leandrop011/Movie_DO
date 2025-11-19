import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final movieTopProvider = Provider<Movie>( 
  (ref){
    final nowPlaying = ref.read(nowPlayingMoviesProvider);
    final movie = nowPlaying[0];//* Tomamos el primer valor del datasource
    
      return movie;
  }
);