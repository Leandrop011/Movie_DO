

import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/infrastructure/models/moviedb/moviedb.dart';

class VideoMapper {

  static Video moviedbVideoToEntity( Result moviedbVideo ) => Video(
    id: moviedbVideo.id, 
    name: moviedbVideo.name, 
    youtubeKey: moviedbVideo.key,
    publishedAt: moviedbVideo.publishedAt
  );


}

