

import 'package:movies_app/features/movies/domain/entities/entities.dart';
abstract class ActorsDatasource {
  
  Future<List<Actor>> getActorByMovie(String movieid);

}

