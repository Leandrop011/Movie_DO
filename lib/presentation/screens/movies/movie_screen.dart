import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/movies/movie_info_provider.dart';
import 'package:movies_app/presentation/providers/providers.dart';

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
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
  }
  
  @override
  void dispose() {
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    //todo, le mandamos el id
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if(movie == null ){
      return Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 4,),));
    }

    return Scaffold(
      
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [

          _CustomSliverAppBar(movie: movie)
        ],
      ),

      
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;//* para saber las dimensiones del dispositivo
    
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      flexibleSpace: FlexibleSpaceBar(//* contenido
        titlePadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5
        ),
        title: Text(
          movie.title,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.start,          
        ),

        //* contenido
        background: _ContentSilverAppBar(movie: movie),
      ),
    );
  }
}

class _ContentSilverAppBar extends StatelessWidget {
  const _ContentSilverAppBar({
    required this.movie,
  });

  final Movie movie;

  //todo, implementar metodo, para no repetir el gradient

  @override
  Widget build(BuildContext context) {
    return Stack(//* el fondo
      children: [
        SizedBox.expand(
          child: Image.network(
            movie.posterPath,
            fit: BoxFit.cover,
          ),
        ),
    
        SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,//* inicio
                end: Alignment.bottomCenter,//* final
                stops: [0.7, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black87
                ]
              )
            )
          ),
        ),
    
        SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                stops: [0.0, 0.4],
                colors: [
                  Colors.black87,//* comienza con el color y luego la transparencia
                  Colors.transparent,
                ]
              )
            )
          ),
        )
      ],
    );
  }
}