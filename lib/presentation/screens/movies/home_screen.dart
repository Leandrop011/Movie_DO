import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/presentation/providers/providers.dart';

//todo, dotenv es para mover archivos de entorno hacia la app
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:movies_app/config/constants/environment.dart';

class HomeScreen extends StatelessWidget {

  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Scaffold(
      
        body: _HomeView(),
      
        bottomNavigationBar: CustomBottomNavigationbar(),
      ),
    );
  }
}

/*
  todo, el StateLes solo sirve para leer y reaccionar a los providers
  todo, miestras que el stateful tienes poder del initsate y riverpod
  todo, el initsate es el lugar ideal para inicializar cosas que tu widget necesita antes de renderizarse. 
  todo, el initsate: se ejecuta una sola vez, antes del primer render y es para inicializar lógica o cargar datos
*/

//todo consumer de un ful para los providers 
class _HomeView extends ConsumerStatefulWidget {
  
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();
    //todo, aqui simplemente se dice que cargue peliculas para comenzar
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //todo, provider que determina si los provider ya  tienen data y asi hacer lo que se dice
    final initialLoading = ref.watch(initialLoadingProvider);

    if(initialLoading == true ) return CustomFullscreenLoading();

    //todo, renderizar la data, llamamos al repository
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    //todo, es un provider que me da solo 6 de las peliculas que hay en esa lista de movies
    final slideShowMovies = ref.read(moviesSlideshowProvider);
    //todo, provider que da las peliculas populares
    final popularMovies = ref.watch(popularMoviesProvider);
    //todo, provider que da las peliculas up coming
    final upcomingMovies = ref.watch(upComingMoviesProvider);
    //todo, provider que da las peliculas top rated
    final topratedMovies = ref.watch(topRatedMoviesProvider);

    final finishLoadinf = ref.watch(visibilityMoviesProvider);

    return Visibility(//* para mostrar cuando todo este cargado(estilo visual)
      visible: finishLoadinf,

      replacement: SizedBox.shrink(),//* para que no ocupe espacio
      child: CustomScrollView(//todo, para controlar el scroll
      
        physics: BouncingScrollPhysics(),
        slivers: [
      
          SliverAppBar(//todo, appbar de un sliver(constrolara que si subimos un poco aparece)
            floating: true,//* para que aparezca cuando se sube un poco
            flexibleSpace: FlexibleSpaceBar(//todo widget que hicimos para el appbar
              
              title: Padding(
                padding: EdgeInsetsGeometry.only(right: 50),
                child: CustomAppbar()),
            ),
          ),
      
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
      
                  children: [
      
                    //todo, widget que dibuja un carrucel de peliculas
                    MoviesSlideshow(movies: slideShowMovies),
      
                    //todo
      
                    //* Peliculas en Cines
      
                    MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'En cines',
                      subTitle: 'Lunes 20', 
                      loadNextPage: () {
                        //todo, le pedimos que nos carge mas peliculas(infity scroll)
                        ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                      },
                    ),
      
                    //* Peliculas Populares
      
                    MovieHorizontalListview(
                      movies: popularMovies,
                      title: 'Populares',
                      subTitle: 'En este mes', 
                      loadNextPage: () {
                        //todo, le pedimos que nos carge mas peliculas(infity scroll)
                        ref.read(popularMoviesProvider.notifier).loadNextPage();
                      },
                    ),
      
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
                      loadNextPage: () {
                        //todo, le pedimos que nos carge mas peliculas(infity scroll)
                        ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                      },
                    ),
                
                  ],
                );
              },
      
              //TODO, ENTENDER ESTA PARTE
              childCount: 1,
            )
          )
        ]
      
      ),
    );
  }
}