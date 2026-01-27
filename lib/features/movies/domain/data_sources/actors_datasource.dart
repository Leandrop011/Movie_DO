

import 'package:movies_app/features/movies/domain/entities/actor.dart';
//* VA HACIA SU IMPLEMENTACION
abstract class ActorsDatasource {
  
  Future<List<Actor>> getActorByMovie(String movieid);

}