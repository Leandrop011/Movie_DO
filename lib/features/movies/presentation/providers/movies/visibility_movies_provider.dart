
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';

final visibilityMoviesProvider = Provider(
  (ref) {
    final value = ref.watch(initialLoadingProvider);

    if(value == true) return false;

    return true;
  }
);

