
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/presentation/providers/storage/storage.dart';

// * PROVIDER QUE NOS DA Y COLOCA UNA PELICULA FAVORITA TRUE OR FALSE
final isFavoriteMovieProvider = FutureProvider.family<bool, int>(
  (ref, movieId){

    final localStorageRepository = ref.watch(localStorageRepositoryProvider);
    return localStorageRepository.isFavoriteMovie(movieId);
  }
);

