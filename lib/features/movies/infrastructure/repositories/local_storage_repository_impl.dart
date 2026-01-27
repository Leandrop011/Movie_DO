import 'package:movies_app/features/movies/domain/data_sources/local_storage_datasource.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  
  //*Esto es nuestro origen de datos y que implementaremos en algun repositorio que deseemos usar 
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl(this.datasource);

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    return datasource.isFavoriteMovie(movieId);
  }

  @override
  Future<List<Movie>> loadFavoriteMovies({int limit = 10, int offset = 0}) {
    return datasource.loadFavoriteMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) {
    return datasource.toggleFavoriteMovie(movie);
  }
  
}