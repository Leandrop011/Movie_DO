

import 'package:movies_app/domain/entities/actor.dart';
import 'package:movies_app/infrastructure/models/moviedb/credits_response.dart';

//todo, para poder acoplar a nuestro modelo de negocio de actor
class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id != 0 ? cast.id : 0, 
    name: cast.name, 
    profilePath: cast.profilePath != null
    ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
    : 
    'https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png' , 
    character: cast.character ?? 'Not Found',
  );
}