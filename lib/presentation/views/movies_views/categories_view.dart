//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/providers/movies/movies_providers.dart';
import 'package:movies_app/presentation/widgets/movies/movies_masonry.dart';

class CategoriesView extends ConsumerStatefulWidget {
  const CategoriesView({super.key});

  @override
  ConsumerState<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends ConsumerState<CategoriesView> {

  @override
  void initState() {
    super.initState();
    ref.read(popularMoviesProvider.notifier).loadNextPage();//*INIVIALIZAMOS LA DATA
  }

  void infoMake(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Peliculas Populares'),
          content: Text('Aquí puedes descubrir las películas más populares del momento. La lista se actualiza constantemente y te muestra las tendencias más recientes según las valoraciones y el interés del público. Selecciona una película para ver más detalles como su sinopsis, puntuación y fecha de lanzamiento.'),
          actions: [ 
            FilledButton(
              onPressed: (){
                context.pop();
              }, 
              child: Text('OK')
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final movies = ref.watch(popularMoviesProvider);
    final style = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('POPULARS', style: style.titleLarge,),
        actions: [
          IconButton(
            onPressed: (){
              infoMake(context);
            }, 
            icon: Icon(Icons.info_outline)
          )
        ],
      ),
      body: MoviesMasonry(
        movies: movies, 
        loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
      )
    );
  }
}