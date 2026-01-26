import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/domain/entities/actor.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';
import 'package:movies_app/presentation/providers/providers.dart';
import 'package:movies_app/presentation/widgets/shared/custom_bottom_favorites.dart';
import 'package:movies_app/presentation/widgets/videos/videos_from_movie.dart';


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

    //todo, para peliculas similares
    ref.read(similarMoviesProvider.notifier).loadSimilarMovies(widget.movieId);
  }
  
  @override
  void dispose() {
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    //todo, le mandamos el id
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    // final isDarck = ref.read(isdarckProvider);
    
    
    if(movie == null ){
      return Scaffold(
        body: Center(
          child: CustomFullscreenLoading()
        )
      );
    }

    return FadeInDown (
      // duration: Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      child: Scaffold(
        
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
      
        
      ),
    );
  }
}

//* DETALLES DE LA PELICULA
class _MovieDetails extends ConsumerWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    final isDarck = ref.read(isdarckProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        //* INFORMACION DE LA MOVIE
        _ElementsInDetails(isDarck: isDarck, size: size, movie: movie, textStyle: textStyle),

        //* VIDEO DE LA MOVIE
        VideosFromMovie(movieId: movie.id),

        Padding(//* GENEROS DE LA MOVIE
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ))
            ],
          ),
        ),

        //* ACTORES DE LA MOVIE
        _ActorsByMovie(movieId: movie.id.toString()),

        //* TITULO DE SIMILARES
        _PreSimilarMoviesView(size: size, textStyle: textStyle, movieId: movie.id.toString(),),

        //* PELICULAS SIMILARES
        _MoviesSimilars(movieId: movie.id.toString()),

        const SizedBox(height: 20),
        
      ],
    );
  }
}

//* ELEMENTOS QUE ESTARAN DENTRO DE LA CAJA DE PELICULA(like overview), TITLE, DETAILS
class _ElementsInDetails extends StatelessWidget {
  const _ElementsInDetails({
    required this.isDarck,
    required this.size,
    required this.movie,
    required this.textStyle,
  });

  final bool isDarck;
  final Size size;
  final Movie movie;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDarck ?
          const Color.fromARGB(255, 42, 42, 42)
          :
          const Color.fromARGB(255, 225, 224, 224),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isDarck ?
              const Color.fromARGB(255, 73, 72, 72)
              :
              const Color.fromARGB(255, 134, 132, 132), 
              blurRadius: 6,
              offset: Offset(1, 3)
            )
          ]
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: 15, right: 5, left: 5, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Image.network(
                      width: size.width * 0.3,
                      movie.posterPath,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if(loadingProgress != null){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return child;
                      },
                    ),
                  ),

                  //* BOTON PERSONALIZADO
                  // CustomBottomFavorites(movie: movie, isDarck: isDarck,)
                ],
              ),
              
              SizedBox(width: 10,),
          
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        movie.title, 
                        style: textStyle.titleMedium,
                      ),
                    ),
                    
                    SizedBox(height: 10,),

                    SizedBox(
                      height: size.height * 0.2,
                      width: double.infinity,
                      child: Text(
                        movie.overview, 
                        style: textStyle.titleSmall,
                        maxLines: 9,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}



//* TITULO QUE DICE "Recomendaciones" ANTES DE MOSTRAR LAS PELICULAS
class _PreSimilarMoviesView extends ConsumerWidget {
  const _PreSimilarMoviesView({
    required this.size,
    required this.textStyle, 
    required this.movieId,
  });

  final Size size;
  final TextTheme textStyle;
  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isDarck = ref.read(isdarckProvider);
    final moviesById = ref.watch(similarMoviesProvider);
    final movies = moviesById[movieId] ?? [];
    
    if (movies.isEmpty){
      return SizedBox();
    }
    
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 15, left: 10, right: 10, top: 10),
      child: SizedBox(
        width: size.width * 1,
        height: size.height * 0.065,
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: isDarck?
            const Color.fromARGB(255, 42, 42, 42)
            :
            const Color.fromARGB(255, 225, 224, 224)
            ,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
              color: const Color.fromARGB(255, 96, 94, 94),
              blurRadius: 6,
              offset: Offset(1, 2),
            )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Recomendaciones', 
              style: textStyle.titleMedium,
            ),
          ),
        )
      ),
    );
  }
}
//* WIDGET QUE NOS DA LISTA DE PELICULAS SIMILARES
class _MoviesSimilars extends ConsumerWidget {
  final String movieId;
  const _MoviesSimilars({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //lista de peliculas
    final moviesById = ref.watch(similarMoviesProvider);//* mapa que da el provider
    final moviesSimilars = moviesById[movieId] ?? [];//* lo transformamos

    if(moviesById[movieId] == null){
      return CircularProgressIndicator();
    }

    if(moviesSimilars.isEmpty){
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        
        height: 330,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
      
          itemCount: moviesSimilars.length,
          itemBuilder: (context, index) {
            final moviesimilar = moviesSimilars[index];
      
            return _MovieSimilarView(movie: moviesimilar);
          },
        )
      ),
    );
  }
}
// ! ALGO MUY IMPORTANTE USAR EL SIZEDBOX PARA DEFINIR MAXIMOS TAMANOS Y NO EXISTA EL DESVORDAMIENTO
//* WIDGET QUE LE DA DISENO A CADA PELICULA SIMILAR DE LA LISTA DE ARRIBA
class _MovieSimilarView extends StatelessWidget {
  final Movie movie;
  const _MovieSimilarView({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return SizedBox(
      width: size.width * 0.35,
      height: size.height * 0.25,
      child: FadeInRight(
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              //! LA DIRECCION DE LA RUTA CAMBIO PORQUE AHORA ES /HOME, YA NO ES DE DIRECCION RAIZ /
              context.push('/home/0/movie/${movie.id}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //* Imagen de la Movie
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: size.height * 0.25,//* le decimos que tome solo una parte no todo
                    child: FadeInImage(
                      width: double.infinity,
                      height: double.infinity,
                          
                      placeholder: AssetImage('assets/loaders/bottle-loader.gif'), 
                      
                      fit: BoxFit.cover,
                      
                      image:  NetworkImage(
                        movie.posterPath,
                      ),
                    ),
                  ) 
                 
                ),
            
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 3),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      movie.title, 
                      maxLines: 2,
                      style: textStyle.titleSmall,
                    ),
                  ),
                ),
                
                Row(
                  children: [
                    Icon(Icons.star_half_outlined, color: Colors.amber.shade800,),
                    SizedBox(width: 3,),
                    Text(
                      movie.voteAverage.toString(),
                      style: TextStyle(
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ],
                ),
            
              ],
            ),
          ),
        ),
      ),
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
      return Center(child: CircularProgressIndicator());
    }

    final actors = actorsByMovie[movieId]!;


    return SizedBox(
      height: 265,
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

//* CAJA DE CADA ACTOR (DISENO) Y SU INFORMACION
class _ActorView extends StatelessWidget {

  final Actor actor;
  const _ActorView({required this.actor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(//? DEFINE EL TAMANO DE TODA LA 'TARJETA' CON IMAGEN NOMBRE
      width: size.width * 0.3,
      height: size.height * 0.25,
      child: Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //* Foto de el Actor
            FadeInRight(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(//* DEFINE EL TAMANO QUE LA IMAGEN PUEDE TOMAR
                  width: double.infinity,//* TOMA TODO1 EL TAMANO QUE PUEED
                  height: size.height * 0.2,
                  child: FadeInImage(
                    width: double.infinity,//* TOMAN TODO1 EL TAMANO QUE PUEDEN 
                    height: double.infinity,//* TOMAN TODO1 EL TAMANO QUE PUEDEN
                    placeholder: AssetImage('assets/loaders/bottle-loader.gif'), 
                    
                    fit: BoxFit.cover,
                    
                    image: NetworkImage(
                      actor.profilePath,
                    ),
                  ),
                ) 
                
              ),
            ),

            //* Nombre de el Actor
            SizedBox(height: 5,),
            // const Spacer(),
            Text(
              actor.name, 
              maxLines: 1,
            ),
      
            //* el papel que interpretaron 
            Text(
              actor.character ?? '', 
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis
              ),
            )
          ],
        ),
      ),
    );
  }
}



//* APPBAR
class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final size = MediaQuery.of(context).size;//* para saber las dimensiones del dispositivo
    // final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(movie.id));
    final isDarck = ref.watch(isdarckProvider);

    //! toma el color blacno o negro dependiendo del contexto del theme
    //final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    
    return SliverAppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      leading: IconButton(
        onPressed: (){
          //* Es distinto de como apilar y desapilar con el push y pop, este coloca y ya no apila
          context.go('/');//es como teletransporstarse hacia otra pantalla, en lugar de ir una por una
        }, 
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)
      ),

      actions: [//! PARA QUE FUNCIONE LA PARTE DE FAVORITOS, USA LA BASE DE DATOS LOCAL
          CustomBottomFavorites(//* BOBTON A PARTE PERSONALIZADO
            movie: movie, 
            isDarck: isDarck
          )      
      ],
        // IconButton(
        //   //!SOLO SI SE PRESIONA ESE BOTON SE HACEN LOS CAMBIOS EN EL PROVIDER
        //   onPressed: () async{//!ESTE ASYN ES MUY IMPORTANTA PARA EL AWAIT 
        //     //* AQUI LEEMOS Y PODEMOS ACTUALIZAR AGREGAR O REMOVER DE FAVORITOS A UNA MOVIE Y TAMBIEN LOS CAMBIOS EN LA BASE DE DATOS
        //     //* LE MANDAMOS ESA PELICULA Y AHI HACE LA CONSULTA CON LA BASE DE DATOS Y DECICE SI REMOVER O AGREGAR
        //     await ref.read(favoriteMoviesProvider.notifier).toggleFavoriteMovie(movie);
        //     ref.invalidate(isFavoriteMovieProvider(movie.id));//* ESTO ES PARA INVALIDAR AL PROVIDER Y ASI CAMBIE EL ICONO(ASI CONSULTA A LA BASE DE DATOS OTRA VEZ)
        //   },
        //   //* EL FUTURE DEL PROVIDERFUTURE NOS AYUDA MUCHO PORQUE NOS DEJA TENER LOS 3 ESTADOS
        //   icon: isFavoriteFuture.when(
        //     data: (isFavorite) => isFavorite == true ?
        //     Icon(Icons.favorite, color: Colors.red,)
        //     :
        //     Icon(Icons.favorite_outline_rounded),
        //     error: (_, __) => throw Exception("Error al cargar el estado de favoritos"), 
        //     loading: () => Center(
        //       child: CircularProgressIndicator(strokeWidth: 4,)
        //     )
        //   ), 
        // )

      expandedHeight: size.height * 0.7,

      flexibleSpace: FlexibleSpaceBar(//*contenido
        //* contenido
        background: _ContentSilverAppBar(movie: movie),

        //! ESTO ES PARA QEU EL GRADIENTE PARA QUE SE VEA EL TITULO EN PELICUALS CON FONDO BLANCO
        //! SE MUEVA INCLUSO SI BAJO LA PANTALLA  
        titlePadding: const EdgeInsets.only(bottom: 0),
        title:  _CustomGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.8, 1],
          colors: [
            Colors.transparent,
            Colors.black87
          ]
        ),
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
    //final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Stack(//* el fondo
      children: [

        Expanded(
          child: ClipRRect(
            child: SizedBox.expand(
             
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return child;
                },
              ),
            ),
          ),
        ),

        // //*GRADIENTE DE LA PARTE BAJA
        // _CustomGradient(
        //   begin: Alignment.topCenter, 
        //   end: Alignment.bottomCenter, 
        //   stops: [0.8, 1.0],
        //   colors: [Colors.transparent, scaffoldBackgroundColor]
        // ),

        //*GRADIENTE DE LA FLECHA DE REGRESO
        _CustomGradient(
          begin: Alignment.topLeft, 
          stops: [0.0, 0.4],
          colors: [Colors.black87, Colors.transparent]
        ),

        //*GRADIENTE DE EL BOTON DE FAVORITOS
        _CustomGradient(
          begin: Alignment.topRight, 
          end: Alignment.bottomCenter, 
          stops: [0.0, 0.2],
          colors: [Colors.black87, Colors.transparent]
        ),
        
      ],
    );
  }
}




//* COMO NECESITAMOS ALGUNOS GRADIENTES SIMILARES, HACEMOS UN METODO DE CUSTOMGRADIENT
//* PARA NO REPETIR CODIGO
class _CustomGradient extends StatelessWidget {
  
  final Alignment begin;
  final Alignment? end;//*ES OPCIONAL
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.begin, 
    this.end, 
    required this.stops,
    required this.colors, 
  });

  //begin  
  //end
  //stops []
  //colors []

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,//* inicio
                end: end ?? Alignment.center,//* final
                stops: stops,
                colors: colors
              )
            )
      ),
    );
  }
}



