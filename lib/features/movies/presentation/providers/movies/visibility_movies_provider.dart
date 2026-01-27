
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';

//todo, para saber si la pantalla de carga ya termino y
//todo, este providder va a dar un bool para Visibility
final visibilityMoviesProvider = Provider(
  (ref) {
    final value = ref.watch(initialLoadingProvider);

    if(value == true) return false;

    return true;
  }
);