import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/entities/video.dart';
//todo, el repositorio es al que vamos a llamar, si queremos otro
//todo, datasource pues solo cambiaremos el repositorie
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