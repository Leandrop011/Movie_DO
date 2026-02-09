

import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/infrastructure/models/moviedb/index.dart';

class VideoMapper {

  static moviedbVideoToEntity( Result moviedbVideo ) => Video(
    id: moviedbVideo.id, 
    name: moviedbVideo.name, 
    youtubeKey: moviedbVideo.key,
    publishedAt: moviedbVideo.publishedAt
  );


}
