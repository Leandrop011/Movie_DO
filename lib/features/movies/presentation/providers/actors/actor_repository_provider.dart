

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/infrastructure/datasources/actor_moviedb_datasource_implementation.dart';
import 'package:movies_app/features/movies/infrastructure/repositories/actors_moviedb_repository_implementation.dart';

final actorRepositoryProvider = Provider(
  (ref){
    return ActorsMoviedbRepositoryImplementation( ActorMoviedbDatasourceImplementation());
  }
);