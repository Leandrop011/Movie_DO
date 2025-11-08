import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/actor.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/providers.dart';

//todo, AQUI SE MUESTRAN LOS DETALLES, ACTORES, Y GENEROS DE LA PELICULA SELECCIONADA
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
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
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

          _CustomSliverAppBar(movie: movie),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie,),
              childCount: 1,
            )
          ),
        ],
      ),

      
    );
  }
}

//* DETALLES DE LA PELICULA
class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    //* para saber el tamano del dispositivo y asi aplicar un tamanao bueno pa todos
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.network(
                  width: size.width * 0.3,
                  movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
              
              SizedBox(width: 10,),

              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleLarge,),
                    SizedBox(height: 10,),
                    Text(
                      movie.overview, 
                      style: textStyle.titleSmall,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    )

                  ],
                )
              )
            ],
          ),
        ),

        //* GENEROS DE LA PELICULA
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Wrap(
            children: [
              //* obtengo los generos disponibles y para eso hago un mapeo, porque son algunos
              //* generos como accion, suspenso y asi 
              ...movie.genreIds.map((gender) => Container(
                margin: EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                ),
              ))
            ],
          ),
        ),



        //* WIDGET QUE HARA TODA LAS LISTVIEW DE LOS ACTORES, DEPENDIENDO DEL ID
        _ActorsByMovie(movieId: movie.id.toString()),


        SizedBox(height: 50,),

        
      ],
    );
  }
}

//* ACTORES DE LA PELICULA
class _ActorsByMovie extends ConsumerWidget {
  

  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if(actorsByMovie[movieId]== null){
      return CircularProgressIndicator();
    }

    final actors = actorsByMovie[movieId]!;


    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return _ActorView(actor: actor);
        },
      ),
    );
  }
}

//* CAJA DE CADA ACTOR Y SU INFORMACION
class _ActorView extends StatelessWidget {

  final Actor actor;
  const _ActorView({required this.actor});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(8),
      width: 135,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Foto de el Actor
          FadeInRight(
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Image.network(
                actor.profilePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          //* Nombre de el Actor

          SizedBox(height: 5,),

          Text(
            actor.name, 
            maxLines: 2,
          ),

          //* el papel que interpretaron 
          Text(
            actor.character ?? '', 
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis
            ),
          )
        ],
      ),
    );
  }
}


//* APPBAR
class _CustomSliverAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;//* para saber las dimensiones del dispositivo
    
    return SliverAppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: (){
          context.pop();
        }, 
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)
      ),
      expandedHeight: size.height * 0.7,
      flexibleSpace: FlexibleSpaceBar(//*contenido

        //* contenido
        background: _ContentSilverAppBar(movie: movie),

        
      ),
    );
  }
}


//* CONTENIDO DE LA APPBAR, MUESTRA LA PELICULA Y SU NOMBRE
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

        ClipRRect(
          child: SizedBox.expand(
            child: Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress){
                if(loadingProgress != null) return SizedBox();

                return FadeIn(child: child);
              },
            ),
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


