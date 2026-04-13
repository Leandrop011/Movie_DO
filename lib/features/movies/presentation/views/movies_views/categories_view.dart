//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
import 'package:movies_app/features/movies/presentation/widgets/movies/movies.dart';
import 'package:movies_app/features/movies/presentation/widgets/shared/shared.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesView extends ConsumerStatefulWidget {
  const CategoriesView({super.key});

  @override
  ConsumerState<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends ConsumerState<CategoriesView> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    ref.read(popularMoviesProvider.notifier).loadNextPage();//*INICIALIZAMOS LA DATA
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final movies = ref.watch(popularMoviesProvider);
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;
    // final colors = Theme.of(context).colorScheme;

    if(movies.isEmpty) return const CustomFullscreenLoading();

    return Scaffold(
      appBar: CustomAppbarTransparent( 
        tittle: 'POPULARES', 
        leadingIcon: Icons.thumb_up_alt_outlined, 
        actions: [
          IconButton(
            onPressed: (){
              CustomInfomakeShowdialog.infoMake(
                context, 
                'Populares', 
                'Aqui puedes descubrir las peliculas mas populares del momento. La lista se actualiza constantemente y te muestra las tendencias mas recientes segun las valoraciones y el interes del publico. Selecciona una pelicula para ver mas detalles como su sinopsis, puntuacion y fecha de lanzamiento.', 
                [
                  FilledButton(
                    onPressed: (){
                      context.pop();
                    }, 
                    child: const Text('Ok')
                  )
                ],
                style,
              );
            }, 
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.info_outline, size: size.width * 0.065),
            )
          )
        ],
        blurIntensity: 50, 
      ),
      body: MoviesMasonry(
        movies: movies, 
        loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
      )
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

