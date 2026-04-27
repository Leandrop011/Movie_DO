
import 'package:movies_app/features/movies/domain/data_sources/data_sources.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/domain/repositories/repositories.dart';

class MovieMovieDbRepositoryImplementation extends MoviesRepositorie{
  
  final MoviesDatasource datasource;

  MovieMovieDbRepositoryImplementation( this.datasource );
 
  //* PRIMER REPOSITORY
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
  
  //* SEGUNDO REPOSITORY
  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }
  
  //* TERCER REPOSITORY
  @override
  Future<List<Movie>> getUpComing({int page = 1}) {
    return datasource.getUpComing(page: page);
  }

  //* CUARTO REPOSITORY
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }
  
  //* QUINTO REPOSITORY(DEVUELVE UNA PELICULA POR ID)
  @override
  Future<Movie> getMovieById(String id) {
    return datasource.getMovieById(id);
  }
  
  //* SEXTO REPOSITORIO QUE DA LISTA DE PELICULAS SEGUN EL QUERY QUE MANDEMOS
  @override
  Future<List<Movie>> searchMovies(String query) {
    return datasource.searchMovies(query);
  }
  
  //* SEPTIMO RESPOSITORIO QUE DA LISTA DE PELICULAS SIMILAR SEGUN SU ID
  @override
  Future<List<Movie>> getMoviesSimilar(String id) {
    return datasource.getMoviesSimilar(id);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int moviId) {
    return datasource.getYoutubeVideosById(moviId);
  }
  
}

