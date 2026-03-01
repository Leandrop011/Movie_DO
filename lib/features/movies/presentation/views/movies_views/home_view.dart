import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/presentation/delegates/index.dart';

import 'package:movies_app/features/movies/presentation/providers/index.dart';
import '../../widgets/movies/movie_top.dart';
/*
  todo, el StateLes solo sirve para leer y reaccionar a los providers
  todo, miestras que el stateful tienes poder del initsate
  todo, el initsate es el lugar ideal para inicializar cosas que tu widget necesita antes de renderizarse. 
  todo, el initsate: se ejecuta una sola vez, antes del primer render y es para inicializar lÃ³gica o cargar datos
*/

//todo consumer de un ful para los providers 
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin {
  bool _deferredLoadsRequested = false;

  @override
  void initState(){
    super.initState();

    //todo, aqui simplemente se dice que cargue peliculas para comenzar
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    //ref.read(popularMoviesProvider.notifier).loadNextPage();
    //todo, carga diferida para no bloquear el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _deferredLoadsRequested) return;
      _deferredLoadsRequested = true;
      ref.read(upComingMoviesProvider.notifier).loadNextPage();
      ref.read(topRatedMoviesProvider.notifier).loadNextPage();
      //ref.read(popularMoviesProvider.notifier).loadNextPage();
    });
    
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //! VARIABLE PARA OBTENER EL TAMANO DEL DISPOSITIVO
    final size = MediaQuery.of(context).size;
    //! Para obtener el color del tema
    final colors = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    //todo, provider que determina si los provider ya  tienen data y asi hacer lo que se dice
    final initialLoading = ref.watch(initialLoadingProvider);
    

    // ! HASTA QUE CARGUE LA DATA PUES MUESTRA ESTO
    if(initialLoading == true ) return CustomFullscreenLoading(); 

    
    FlutterNativeSplash.remove();

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
    
    //? para obtener entre una lista de peliculas en cines 
    final movieTop = ref.read(movieTopProvider);
    
    //? para cuando termine la carga
    // final finishLoadinf = ref.watch(visibilityMoviesProvider);

    //? para obtener si el fount is darck or ligth
    final isDarck = ref.watch(isdarckProvider).fount;

    //* BOUNCE => EFECTO REBOTE DE ANIMATE_DO
    return ZoomIn(//* EFECTO DE ENTRADA COMO UN ZOOM
      duration: const Duration(seconds: 1),
      //curve: Curves.elasticOut,
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
            expandedHeight: size.height * 0.08, 
            title: 'Movie DO',
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isDarck ?
                   colors.primary
                   :
                   Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10)
                  )
                ),
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
                    // ? SI PULSA ALGUNA MOVIE PUES NAVEGA A ESA RUTA
                    // ignore: use_build_context_synchronously
                    context.push('/home/0/movie/${movie.id}');
                  });
                }, 

                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(
                    Icons.search, 
                    size: size.width * 0.055,
                    color: Colors.white
                  ),
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 5),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: isDarck ?
                    Colors.black54
                    :
                    colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10)
                    )
                  ),
                  onPressed: (){
                    ref.read(isdarckProvider.notifier).setFount(!isDarck);
                  }, 
                  child: isDarck ?
                  Icon(Icons.light_mode_outlined, color: Colors.white,size: size.width * 0.035,)
                  :
                  Icon(Icons.dark_mode_rounded, color: Colors.white,size: size.width * 0.035,)
                ),
              )
            
            ],
            leading: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                Icons.movie_outlined,
                size: size.width * 0.055,
                color: colors.primary,
              ),
            ),
            
          ),
      
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
      
                  children: [
                    // const Spacer(),   
                    //* CARTELERA GRANDE DE LA PELICULA MAS POPULAR
                    MovieTop(movie: movieTop),
                    // const Spacer(),
                    //* Peliculas en Cines
                    // const Spacer(),
                    MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'En cines',
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
            
                    
                    // const Spacer(),
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
                    // const Spacer(),
                    MovieHorizontalListview(
                      movies: topratedMovies,
                      title: 'Mejor calificadas',
                      loadNextPage: () {
                        //todo, PAGINACION
                        //todo, le pedimos que nos carge mas peliculas(infity scroll)
                        ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                      },
                    ),

                    SizedBox(height: size.height * 0.03,)
                  ],
                );
              },

            
              //todo, esto le dira cuantos hijos construir(osea cuantas veces construir lo que esta dentro)
              childCount: 1,
            )
          )
        ]
      
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
