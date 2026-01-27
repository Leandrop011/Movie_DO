

import 'package:movies_app/features/movies/domain/entities/actor.dart';

abstract class ActorsRepository {
  
  Future<List<Actor>> getActorByMovie(String movieid);
}