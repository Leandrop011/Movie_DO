import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/features.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';

class ShowMoreMovies extends ConsumerStatefulWidget {

  final String title;

  const ShowMoreMovies({
    super.key, 
    required this.title, 
  });

  @override
  ConsumerState<ShowMoreMovies> createState() => _ShowMoreMoviesState();
}

class _ShowMoreMoviesState extends ConsumerState<ShowMoreMovies> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // * SI EL SCROLL LLEGA AL CASI FINAL DE LOS PIXELES COLOCADOS, PUES HACE OTRA PETICION HTTP
    scrollController.addListener((){
      if(scrollController.position.pixels + 100 >= scrollController.position.maxScrollExtent){

        if (widget.title == 'En cines') {
          ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
        }else if( widget.title == 'Proximamente'){
          ref.read(upComingMoviesProvider.notifier).loadNextPage();
        }else if(widget.title == 'Mejor calificadas'){
          ref.read(topRatedMoviesProvider.notifier).loadNextPage();
        }
      }

    }); 
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isLoadingMovies = ref.watch(initialLoadingProvider);

    if(isLoadingMovies == true) return const CustomFullscreenLoading();

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppbarTransparent(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingButton: true, 
        blurIntensity: 50,
        actions: [
          IconButton(
            onPressed: (){
              CustomInfomakeShowdialog.infoMake(
                context, 
                'Informacion', 
                'En esta seccion podras ver mas peliculas que estan ${widget.title.toLowerCase()} actualmente. Puedes hacer scroll para cargar mas peliculas, y al tocar una pelicula, podras ver su detalle.', 
                [
                  FilledButton(onPressed: (){
                    context.pop();
                  }, 
                  child: const Text('Ok'))
                ], 
                textTheme
              );
            }, 
            icon: const Icon(Icons.info_outline_rounded)
          ),
        ], 
        tittle: widget.title
      ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: MasonryGridView.count(
          crossAxisCount: 3, 
          mainAxisSpacing: 10,//* separacion en y
          crossAxisSpacing: 10,//* separacion en x

          controller: scrollController,
          itemCount: moviesFromTitle().length,
          itemBuilder: (context, index) {
            final movie = moviesFromTitle()[index];
        
            if(index%2 == 0){
              return MoviePosterLink(movie: movie, index: true);
            } 
            
            return MoviePosterLink(movie: movie, index: false,);
          },
        ),
      ),
    );
  }

  List<Movie> moviesFromTitle(){
    // * READ => NO ESUCHA NADA, SOLO LEE EL VALOR QUE HAY Y NOS LOS DA
    // * WATCH => ESUCHA LOS CAMBIOS Y SI HAY UN CAMBIO REDIBUJA LOS WIDGETS

    if (widget.title == 'En cines') {
      return ref.watch(nowPlayingMoviesProvider);
    }else if( widget.title == 'Proximamente'){
      return ref.watch(upComingMoviesProvider);
    }else if( widget.title == 'Mejor calificadas' ){
      return ref.watch(topRatedMoviesProvider);
    }

    return [];
  }
}