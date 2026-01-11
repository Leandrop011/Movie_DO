import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/delegates/search_movie_delegate.dart';

import 'package:movies_app/presentation/providers/providers.dart';
import 'package:movies_app/presentation/widgets/shared/custom_sliver_app_bar.dart';
import '../../providers/movies/movie_top_provider.dart';
import '../../widgets/movies/movie_top.dart';
/*
  todo, el StateLes solo sirve para leer y reaccionar a los providers
  todo, miestras que el stateful tienes poder del initsate y riverpod
  todo, el initsate es el lugar ideal para inicializar cosas que tu widget necesita antes de renderizarse. 
  todo, el initsate: se ejecuta una sola vez, antes del primer render y es para inicializar lógica o cargar datos
*/

//todo consumer de un ful para los providers 
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
    super.initState();
    //todo, aqui simplemente se dice que cargue peliculas para comenzar
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    //ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! VARIABLE PARA OBTENER EL TAMANO DEL DISPOSITIVO
    final size = MediaQuery.of(context).size;
    //! Para obtener el color del tema
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    //todo, provider que determina si los provider ya  tienen data y asi hacer lo que se dice
    final initialLoading = ref.watch(initialLoadingProvider);

    if(initialLoading == true ) return CustomFullscreenLoading(); 

    //todo, renderizar la data, llamamos al repository
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    //todo, es un provider que me da solo 6 de las peliculas que hay en esa lista de movies
    final slideShowMovies = ref.read(moviesSlideshowProvider);
    //todo, provider que da las peliculas populares
    //final popularMovies = ref.watch(popularMoviesProvider);
    //todo, provider que da las peliculas up coming
    final upcomingMovies = ref.watch(upComingMoviesProvider);
    //todo, provider que da las peliculas top rated
    final topratedMovies = ref.watch(topRatedMoviesProvider);
    
    final movieTop = ref.read(movieTopProvider);
    
    final finishLoadinf = ref.watch(visibilityMoviesProvider);
    //* BOUNCE => EFECTO REBOTE DE ANIMATE_DO
    return ZoomIn(//* EFECTO DE ENTRADA COMO UN ZOOM
      duration: Duration(seconds: 1),
      //curve: Curves.elasticOut,
      child: Visibility(//* para mostrar cuando todo este cargado(estilo visual)
        visible: finishLoadinf,
      
        replacement: SizedBox.shrink(),//* para que no ocupe espacio
        child: CustomScrollView(//todo, para controlar el scroll
        
          physics: BouncingScrollPhysics(),
          slivers: [
            
            //! MANANA IMPLEMENTAR UNA APPBAR CON DESENFOQUE Y CON DISENO TRANSPARENTE
            // SliverAppBar (//todo, appbar de un sliver(constrolara que si subimos un poco aparece)
            //   floating: true,//* para que aparezca cuando se sube un poco
            //   flexibleSpace: FlexibleSpaceBar(//todo widget que hicimos para el appbar
              
            //     title: Padding(
            //       padding: EdgeInsetsGeometry.only(right:5, top: 5),
            //       child: CustomAppbar()
            //     ),
            //     centerTitle: true,
              
            //   ),
            // ),
            GlassSliverAppBar(
              expandedHeight: 70, 
              title: 'Movie DO',
              actions: [
                IconButton(
                  onPressed: (){
                    final searchedMovies = ref.read(searchedMoviesProvider);
                    final searchQuery = ref.read(searchQueryProvider);

                    showSearch<Movie?>(
                      context: context, 
                      query: searchQuery,

                      delegate: SearchMovieDelegate(
                        initialMovies: searchedMovies, 
                        searchMovie: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery,
                      ),
                    ).then((movie){
                      if(movie == null) return;
                      context.push('/home/0/movie/${movie.id}');
                    });
                  }, 
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Icon(
                      Icons.search, 
                      size: size.width * 0.1,
                      color: colors.primary,
                    ),
                  ),
                ),
              
              ],
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.movie_outlined,
                  size: size.width*0.1,
                  color: colors.primary,
                ),
              ),
            ),
        
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
        
                    children: [
                          
                      //* CARTELERA GRANDE DE LA PELICULA MAS POPULAR
                      MovieTop(movie: movieTop),
        
                      //* Peliculas en Cines
        
                      MovieHorizontalListview(
                        movies: nowPlayingMovies,
                        title: 'En cines',
                        subTitle: 'Este mes', 
                        loadNextPage: () {
                          //todo, le pedimos que nos carge mas peliculas(infity scroll)
                          ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                        },
                      ),
      
                       //todo, widget que dibuja un carrucel de peliculas
                      MoviesSlideshow(movies: slideShowMovies),
        
                      // //* Peliculas Populares
        
                      // MovieHorizontalListview(
                      //   movies: popularMovies,
                      //   title: 'Populares',
                      //   subTitle: 'En este mes', 
                      //   loadNextPage: () {
                      //     //todo, le pedimos que nos carge mas peliculas(infity scroll)
                      //     ref.read(popularMoviesProvider.notifier).loadNextPage();
                      //   },
                      // ),
      
                      
        
                      //* Peliculas Proximamente
        
                      MovieHorizontalListview(
                        movies: upcomingMovies,
                        title: 'Proximamente',
                        //subTitle: 'En este mes', 
                        loadNextPage: () {
                          //todo, le pedimos que nos carge mas peliculas(infity scroll)
                          ref.read(upComingMoviesProvider.notifier).loadNextPage();
                        },
                      ),
        
                      //* Peliculas Mejor Calificadas
        
                      MovieHorizontalListview(
                        movies: topratedMovies,
                        title: 'Mejor calificadas',
                        subTitle: 'Desde siempre', 
                        heightN: true,
                        widthN: true,
                        loadNextPage: () {
                          //todo, PAGINACION
                          //todo, le pedimos que nos carge mas peliculas(infity scroll)
                          ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                        },
                      ),
                  
                    ],
                  );
                },
        
                //todo, esto le dira cuantos hijos construir(osea cuantas veces construir lo que esta dentro)
                childCount: 1,
              )
            )
          ]
        
        ),
      ),
    );
  }
}