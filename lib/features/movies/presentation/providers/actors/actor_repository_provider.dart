

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/infrastructure/datasources/datasources.dart';
import 'package:movies_app/features/movies/infrastructure/repositories/repositories.dart';

final actorRepositoryProvider = Provider(
  (ref){
    return ActorsMoviedbRepositoryImplementation( ActorMoviedbDatasourceImplementation());
  }
);

