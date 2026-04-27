import 'package:movies_app/features/movies/domain/entities/entities.dart';

abstract class LocalStorageDatasource {

  Future<void> toggleFavoriteMovie(Movie movie);

  Future<bool> isFavoriteMovie(int movieId);

  Future<List<Movie>> loadFavoriteMovies({
    int limit = 10, //* PAGINACION
    int offset = 0 
  });

}

