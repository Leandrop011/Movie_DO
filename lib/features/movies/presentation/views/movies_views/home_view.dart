import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/delegates/delegates.dart';
import 'package:movies_app/features/movies/presentation/widgets/widgets.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    
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

    final initialLoading = ref.watch(initialLoadingProvider);
    

    // ! HASTA QUE CARGUE LA DATA PUES MUESTRA ESTO
    if(initialLoading == true ) return const CustomFullscreenLoading(); 

    
    FlutterNativeSplash.remove();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.read(moviesSlideshowProvider);
    final upcomingMovies = ref.watch(upComingMoviesProvider);
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
      child: CustomScrollView(
      
        physics: const BouncingScrollPhysics(),
        slivers: [
          
          GlassSliverAppBar(
            expandedHeight: size.height * 0.08, 
            title: 'Movie DO',
            actions: [
              // ? BOTON QUE BUSCA PELICULAS
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

                  // ? Vibracion pequena
                  HapticFeedback.lightImpact();
      
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

                    HapticFeedback.lightImpact();

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
                size: size.width * 0.065,
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
                      loadNextPage: () {
                        ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                      },
                    ),
            
                     // * Widget que dibuja un carrucel de peliculas
                    MoviesSlideshow(movies: slideShowMovies),
            
                    
                    // const Spacer(),
                    //* Peliculas Proximamente
      
                    MovieHorizontalListview(
                      movies: upcomingMovies,
                      title: 'Proximamente',
                      //subTitle: 'En este mes', 
                      loadNextPage: () {
                        ref.read(upComingMoviesProvider.notifier).loadNextPage();
                      },
                    ),

                    //* Peliculas Mejor Calificadas
                    // const Spacer(),
                    MovieHorizontalListview(
                      movies: topratedMovies,
                      title: 'Mejor calificadas',
                      loadNextPage: () {
                        ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                      },
                    ),

                    SizedBox(height: size.height * 0.05,)
                  ],
                );
              },

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

