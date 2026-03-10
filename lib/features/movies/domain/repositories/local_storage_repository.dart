import 'package:movies_app/features/movies/domain/entities/entities.dart';

abstract class LocalStorageRepository {
  Future<void> toggleFavoriteMovie(Movie movie);

  Future<bool> isFavoriteMovie(int movieId);

  Future<List<Movie>> loadFavoriteMovies({
    int limit = 10, //* PARA PAGINACION(SABER CUANTAS DEBE CARGAR POR CADA PETICION HTTP)
    int offset = 0 //* CUANTAS PELICULAS ME QUIERO SALTAR SEGUN LA PAGINACION
  });
}

