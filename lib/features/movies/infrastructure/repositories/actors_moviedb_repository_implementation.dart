
import 'package:movies_app/features/movies/domain/data_sources/data_sources.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/domain/repositories/repositories.dart';

class ActorsMoviedbRepositoryImplementation extends ActorsRepository{
  final ActorsDatasource datasource;

  ActorsMoviedbRepositoryImplementation(this.datasource);

  //todo, PRIMER RESPOSITORIO INFORMACION DE LOS ACTORES DE LA PELICULA
  @override
  Future<List<Actor>> getActorByMovie(String movieid) {
    return datasource.getActorByMovie(movieid);
  }
  
}

