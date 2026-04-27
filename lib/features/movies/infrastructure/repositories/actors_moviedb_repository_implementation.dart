
import 'package:movies_app/features/movies/domain/data_sources/data_sources.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/domain/repositories/repositories.dart';

class ActorsMoviedbRepositoryImplementation extends ActorsRepository{
  final ActorsDatasource datasource;

  ActorsMoviedbRepositoryImplementation(this.datasource);

  @override
  Future<List<Actor>> getActorByMovie(String movieid) {
    return datasource.getActorByMovie(movieid);
  }
  
}

