

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/infrastructure/datasources/index.dart';
import 'package:movies_app/features/movies/infrastructure/repositories/index.dart';

final actorRepositoryProvider = Provider(
  (ref){
    return ActorsMoviedbRepositoryImplementation( ActorMoviedbDatasourceImplementation());
  }
);
