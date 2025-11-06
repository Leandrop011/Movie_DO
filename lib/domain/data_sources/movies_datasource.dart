//todo, como quiero que venga los origenes de datos

import 'package:movies_app/domain/entities/movie.dart';

abstract class MoviesDatasource {
  //todo, una lista de movie, la info que nos va a dar 
  Future <List<Movie>>getNowPlaying({int page = 1});

  Future <List<Movie>>getPopular({int page = 1});

  Future <List<Movie>>getUpComing({int page = 1});

  Future <List<Movie>>getTopRated({int page = 1});

  Future<Movie> getMovieById(String id);

}
