import 'package:movies_app/features/movies/domain/entities/entities.dart';
abstract class MoviesRepositorie {

  Future <List<Movie>>getNowPlaying({int page = 1});

  Future <List<Movie>>getPopular({int page = 1});

  Future <List<Movie>>getUpComing({int page = 1});

  Future <List<Movie>>getTopRated({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Movie>> searchMovies(String query);

  Future<List<Movie>> getMoviesSimilar(String id);

  Future<List<Video>> getYoutubeVideosById( int moviId );
}

