import 'package:drift/drift.dart' as drift;
import 'package:movies_app/config/database/favorites/favorites.dart';
import 'package:movies_app/features/movies/domain/data_sources/data_sources.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';


//*DATA SOURCE QUE PROVIENE DE LA BASE DE DATOS LOCALES QUE USAMOS CON DRIFT
//!SOLO AQUI MANEGAREMOS COSAS RELACIONADAS A DRIFT
class DriftDatasource extends LocalStorageDatasource {

  final AppDatabase database;

  DriftDatasource([AppDatabase? databaseToUse])
                  : database  = databaseToUse ?? db;

  //* ESTO ES PARA CONSULTARLE SI LA PELICULA QUE LE MANDO ESTA EN FAVORITOS O NO
  @override
  Future<bool> isFavoriteMovie(int movieId) async{
    //Construir el query
    final query = database.select(database.favoritesMovies)//* ESTP DICE QUE QUIERO SELECCIONAR DATOS DE LA TABLA DE FAVORITOS
    ..where((table) => table.movieId.equals(movieId));//* EL WHERE ES PARA FILTRAR Y QUE SOLO ME DE LA FILA DONDE EL MOVIEID SEA IGUAL AL MOVIEID QUE BUSCAMOS
    //Ejecutar el query
    final favoriteMovie = await query.getSingleOrNull();//* EL GET INTENTA OBTENER SOLO UNA FILA SI NO ENCUENTRA DEVUELVE NULL SI ENCUENTRA DEVUELVE LA PELICULA
    //Retornar el resultado
    return favoriteMovie != null;//* DEVUELVE TRUE SI HAY ALGO SINO FALSE
  }

  //* ESTE METODO ME DEVUELVE LA LISTA DE LA TABLA DE FAVORITOS PARA LA VIEW DE FAVORITES MOVIES
  @override
  Future<List<Movie>> loadFavoriteMovies({int limit = 10, int offset = 0}) async{
    //QUERY
    final query =  database.select(database.favoritesMovies)//* EL SELECT ES PARA DECIRLE QUE QUIERO TODAS LAS FILAS DE LA TABLA FAVORITES
    ..limit(limit, offset: offset);//* EL LIMIT ES CUANTOS RESULTADOS ME DE DE LA TABLA POR PAGINA Y EL OFFSET ES PARA SABER DESDE QUE POSICION LEER LOS DATOS(SI ES 0-> 10, 1 -> 20)
    //EJECUTAR EL QUERY
    final favoriteMoviesRows = await query.get();//* ESTO EJECUTA Y TRAE LA LISTA DE FILAS
    //TRANSFORMARLO
    final movies = favoriteMoviesRows.map(//* ESTO ES PARA TRANSFORMAR TODOS LOS ELEMENTOS DE LA TABLA QUE TRAJE A MOVIES
      (row) => Movie(//* TRANFORMAMOS CADA REGISTRO DE LA BASE DE DATOS EN UN ELEMENTO MOVIE(ESO ES LO QEU ESPERA LA APP)
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


  //* ESTE METODO SIRVE PARA MARCAR Y DESENMARCAR UNA PELICULA DE FAVORITOS
  @override
  Future<void> toggleFavoriteMovie(Movie movie) async{
    //
    final isFavorite =  await isFavoriteMovie(movie.id);//* VERIFICACION SI YA ESTA EN FAVORITOS
    //
    if(isFavorite == true){
      //* SECREA ESTE QUERY PARA BORRAR ESA FILA CON ESOS DATOS
      final deleteQuery = database.delete(database.favoritesMovies)
      ..where((tabble) => tabble.movieId.equals(movie.id));//* SE FILTRA SOLO LA PELICULA CON ESE ID

      //* SE EJECUTA EL DELETE
      await deleteQuery.go();

      return;
    }
    //

    //* SI NO ES FAVORITA SE LA AGREGAR, SE LA INTRODUCE EL ELEMENTO A UNA FILA DE LA TABLA
    await database.into(database.favoritesMovies).insert(//* SE LA INSERTA EN LA TABLA DE FAVORITOS, EL ISERT ES PAR AINSERTAR DATOS
      FavoritesMoviesCompanion.insert(//* ESTE SERA EL ELEMNTO CON LOS DATOS QUE SE INSERTARAN EN LA TABLA
        movieId: movie.id,
        backdropPath: movie.backdropPath,
        originalTitle: movie.originalTitle,
        posterPath: movie.posterPath,
        title: movie.title,
        voteAverage: drift.Value(movie.voteAverage),//* ES COMO UN CASTEO
      )
    );
  }
  
}

