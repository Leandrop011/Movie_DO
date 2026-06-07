import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:movies_app/config/config.dart';
import 'package:movies_app/features/features.dart';


class MovieScreen extends ConsumerStatefulWidget {

  static const String name = 'movie-screen';
  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    // * INICIALIZACION DE LA DATA
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    ref.read(similarMoviesProvider.notifier).loadSimilarMovies(widget.movieId);

    // ? PARA INICIALIZAR EL VALOR DEL ID APENAS ENTRE A LA MOVIE PARA LA QUICK DYNAMIC
    ref.read(lastMovieIdQuickActionProvider.notifier).setMovieIdValueQuickAction(widget.movieId);
  }
  
  @override
  Widget build(BuildContext context) {
    
    // ? Le mandamos el id
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    final securutyActive = ref.watch(securityProvider).activeSecurity;
    final authAprove = ref.watch(localAuthProvider).didAuthenticate;
    final isBiometricEnabled = ref.watch(existBiometricProvider).value;
    
    if(movie == null ){
      return const Scaffold(
        body: Center(
          child: CustomFullscreenLoading()
        )
      );
    }
    
    // ? GUARDAMOS EL ID PARA QUICK ACTIONS
    QuickActionsPlugin.registerActions( movieId: movie.id.toString(), titleMovie: movie.title);

    // ? VERIFICACION DE SEGURIDAD
    return (securutyActive == true && isBiometricEnabled == true) ?
      (authAprove == true) ?
      ZoomInDown(
        child: Scaffold(
          
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _HomeView(movie: movie),
                
            ],
          ),
        
          
        ),
      )
      :
      const SecurityScreen()
    :
    ZoomInDown(
      child: Scaffold(
        
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _HomeView(movie: movie),
            
          ],
        ),
      ),
    );
  }
}
// * VIEW DEL HOME
class _HomeView extends StatelessWidget {
  const _HomeView({
    required this.movie,
  });

  final Movie? movie;

  @override
  Widget build(BuildContext context) {

    if(movie == null){
      return const SizedBox();
    }

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        // * Apppbar
        CustomSliverAppBar(movie: movie!),
        // * Contenido
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie!,),
            childCount: 1,
          ),

        ),
      ],
    );
  }
}



//* DETALLES DE LA PELICULA

class _MovieDetails extends ConsumerWidget {

  final Movie movie;

  const _MovieDetails({
    required this.movie
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    final fount = ref.read(isdarckProvider).fount;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        //* INFORMACION DE LA MOVIE
        ElementsInDetails(fount: fount, size: size, movie: movie, textStyle: textStyle),

        DividerSectionsView(fount: fount),

        //* VIDEO DE LA MOVIE SOLO SI EL TIEMPO PASO
        VideosFromMovie(movie: movie,),
        
        // * GENERO DE LA MOVIE
        Genders(movie: movie,),

        // * TITULO DE LOS ACTORES
        TitleCast(textTheme: textStyle, size: size, movieId: movie.id.toString(),),
        
        //* ACTORES DE LA MOVIE
        ActorsByMovie(movieId: movie.id.toString(), fount: fount,),

        //* TITULO DE SIMILARES
        PreSimilarMoviesView(size: size, textStyle: textStyle, movieId: movie.id.toString(),),

        //* PELICULAS SIMILARES
        MoviesSimilars(movieId: movie.id.toString()),
        
      ],
    );
  }
}
