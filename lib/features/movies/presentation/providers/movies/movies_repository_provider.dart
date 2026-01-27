//todo, esto es para proveer la informacion de una lista de peliculas

//todo, el provider encargado de proveer ese repositorio
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/infrastructure/datasources/moviedb_datadource_implementation.dart';
import 'package:movies_app/features/movies/infrastructure/repositories/movie_moviedb_repository_implementation.dart';

//todo, este provider es de solo lectura, solo provee, pero no puede cambiarse su fuente

//todo, retornamos un repositorio con la implementacion de un datasource
//todo, y aqui la ciencia, podemos colocar otro datasource y sin necesidad de cambiar toda la app
final movieRepositoryProvider = Provider((ref) {
  //todo,    devuelve el repositorio      con este datasource
  //todo, requiere el datasource, le mandamos un datasource
  return MovieMovieDbRepositoryImplementation( MoviedbDatadourceImplementation() );
});