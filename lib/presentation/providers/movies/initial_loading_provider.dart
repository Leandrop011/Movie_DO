
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final initialLoadingProvider = Provider<bool>(
  (ref) {

    final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
    //todo, es un provider que me da solo 6 de las peliculas que hay en esa lista de movies
    final step2 = ref.read(moviesSlideshowProvider).isEmpty;
    //todo, provider que da las peliculas populares
    final step3 = ref.watch(popularMoviesProvider).isEmpty;
    //todo, provider que da las peliculas up coming
    final step4 = ref.watch(upComingMoviesProvider).isEmpty;
    //todo, provider que da las peliculas top rated
    final step5 = ref.watch(topRatedMoviesProvider).isEmpty;
    
    //* si etsna cargando y no tienen data devuelve true
    if(step1 || step2 || step3 || step4 || step5) return true;

    //* pero si ya se llenaron de data devuelve false
    return false;
  }
);