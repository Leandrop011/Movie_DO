

import 'package:movies_app/features/movies/domain/entities/entities.dart';

abstract class ActorsRepository {
  
  Future<List<Actor>> getActorByMovie(String movieid);
}

