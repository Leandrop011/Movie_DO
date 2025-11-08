
import 'package:movies_app/domain/data_sources/actors_datasource.dart';
import 'package:movies_app/domain/entities/actor.dart';
import 'package:movies_app/domain/repositories/actors_repository.dart';

class ActorsMoviedbRepositoryImplementation extends ActorsRepository{
  final ActorsDatasource datasource;

  ActorsMoviedbRepositoryImplementation(this.datasource);

  //todo, PRIMER RESPOSITORIO INFORMACION DE LOS ACTORES DE LA PELICULA
  @override
  Future<List<Actor>> getActorByMovie(String movieid) {
    return datasource.getActorByMovie(movieid);
  }
  
}