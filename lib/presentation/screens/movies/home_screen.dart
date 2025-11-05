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
    return Scaffold(

      body: _HomeView(),

      bottomNavigationBar: CustomBottomNavigationbar(),
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
    //todo, aqui simplemente se dice que cargue la primer pagina
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //todo, renderizar la data, llamamos al repository
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    //todo, es un provider que me da solo 6 de las peliculas que hay en esa lista de movies
    final slideShowMovies = ref.read(moviesSlideshowProvider);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          //todo, appbar
          CustomAppbar(),
          //todo, widget que dibuja un carrucel de peliculas
          MoviesSlideshow(movies: slideShowMovies),
      
          //todo, peliculas en Cines
          MovieHorizontalListview(
            movies: nowPlayingMovies,
            title: 'En cines',
            subTitle: 'Lunes 20', 
            loadNextPage: () {
              //todo, le mandamos las peliculas cad avez que llega al final
              ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
            },
          ),

      
        
      
        ],
      ),
    );
  }
}