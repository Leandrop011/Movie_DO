
import 'package:movies_app/features/movies/domain/data_sources/index.dart';
import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/domain/repositories/index.dart';

class ActorsMoviedbRepositoryImplementation extends ActorsRepository{
  final ActorsDatasource datasource;

  ActorsMoviedbRepositoryImplementation(this.datasource);

  //todo, PRIMER RESPOSITORIO INFORMACION DE LOS ACTORES DE LA PELICULA
  @override
  Future<List<Actor>> getActorByMovie(String movieid) {
    return datasource.getActorByMovie(movieid);
  }
  
}
