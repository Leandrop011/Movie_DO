import 'package:drift/drift.dart' as drift;
import 'package:movies_app/config/database/favorites/favorites.dart';
import 'package:movies_app/features/movies/domain/data_sources/data_sources.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';


class DriftDatasource extends LocalStorageDatasource {

  final AppDatabase database;

  DriftDatasource([AppDatabase? databaseToUse])
                  : database  = databaseToUse ?? db;

  @override
  Future<bool> isFavoriteMovie(int movieId) async{
    //Construir el query
    final query = database.select(database.favoritesMovies)
    ..where((table) => table.movieId.equals(movieId));
    //Ejecutar el query
    final favoriteMovie = await query.getSingleOrNull();
    //Retornar el resultado
    return favoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadFavoriteMovies({int limit = 10, int offset = 0}) async{
    //QUERY
    final query =  database.select(database.favoritesMovies)
    ..limit(limit, offset: offset);
    //EJECUTAR EL QUERY
    final favoriteMoviesRows = await query.get();
    //TRANSFORMARLO
    final movies = favoriteMoviesRows.map(
      (row) => Movie(
        adult: false, 
        backdropPath: row.backdropPath, 
        genreIds: const[], 
        id: row.movieId, 
        originalLanguage: '', 
        originalTitle: row.originalTitle,
        overview: '', 
        popularity: 0, 
        posterPath: row.posterPath, 
        releaseDate: DateTime.now(), 
        title: row.title, 
        video: false, 
        voteAverage: row.voteAverage, 
        voteCount: 0
        )
      ).toList();
    
    //retornar
    return movies;
  }


  @override
  Future<void> toggleFavoriteMovie(Movie movie) async{
    //
    final isFavorite =  await isFavoriteMovie(movie.id);
    //
    if(isFavorite == true){
      final deleteQuery = database.delete(database.favoritesMovies)
      ..where((tabble) => tabble.movieId.equals(movie.id));

      //* SE EJECUTA EL DELETE
      await deleteQuery.go();

      return;
    }
    //

    await database.into(database.favoritesMovies).insert(
      FavoritesMoviesCompanion.insert(
        movieId: movie.id,
        backdropPath: movie.backdropPath,
        originalTitle: movie.originalTitle,
        posterPath: movie.posterPath,
        title: movie.title,
        voteAverage: drift.Value(movie.voteAverage),
      )
    );
  }
  
}

