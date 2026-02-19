import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';

// ! PROVIDER QUE REGRESA UNA LIST DE VIDEOS 
final videosFromMovieProvider = FutureProvider.autoDispose.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});