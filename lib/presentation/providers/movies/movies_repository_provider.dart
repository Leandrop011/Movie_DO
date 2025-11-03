//todo, esto es para proveer la informacion de una lista de peliculas

//todo, el provider encargado de proveer ese repositorio
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/infrastructure/datasources/moviedb_datadource_implementation.dart';
import 'package:movies_app/infrastructure/repositories/movie_repositorie_implementation.dart';

//todo, este provider es de solo lectura, solo provee, pero no puede cambiarse su fuente

//todo, retornamos un repositorio con la implementacion de un datasource
//todo, y aqui la ciencia, podemos colocar otro datasource y sin necesidad de cambiar toda la app
final movieRepositoryProvider = Provider((ref) {
  //todo,    devuelve el repositorio      con este datasource
  return MovieRepositorieImplementation( MoviedbDatadourceImplementation() );
});