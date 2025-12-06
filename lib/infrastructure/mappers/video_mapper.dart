

import 'package:movies_app/domain/entities/video.dart';
import 'package:movies_app/infrastructure/models/moviedb/moviedb_videos.dart';

class VideoMapper {

  static moviedbVideoToEntity( Result moviedbVideo ) => Video(
    id: moviedbVideo.id, 
    name: moviedbVideo.name, 
    youtubeKey: moviedbVideo.key,
    publishedAt: moviedbVideo.publishedAt
  );


}