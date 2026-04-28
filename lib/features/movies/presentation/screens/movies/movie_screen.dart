import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);

    // ? para peliculas similares
    ref.read(similarMoviesProvider.notifier).loadSimilarMovies(widget.movieId);

    // ? PARA INICIALIZAR EL VALOR DEL ID APENAS ENTRE A LA MOVIE PARA LA QUICK DYNAMIC
    ref.read(lastMovieIdQuickActionProvider.notifier).setMovieIdValueQuickAction(widget.movieId);


  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    // ? Le mandamos el id
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    // final isDarck = ref.read(isdarckProvider);
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

    

    QuickActionsPlugin.registerActions( movieId: movie.id.toString(), titleMovie: movie.title);

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
// * VIEW DEL HOME VIEW
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

    return Expanded(
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // * Apppbar
          _CustomSliverAppBar(movie: movie!),
          // * Contenido
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie!,),
              childCount: 1,
            ),
            
          ),
        ],
      ),
    );
  }
}



//* DETALLES DE LA PELICULA
class _MovieDetails extends ConsumerStatefulWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  ConsumerState<_MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends ConsumerState<_MovieDetails> {
  bool _showTrailer = false;
  
  // ? Para controlar que no todo cargue a la vez
  @override
  void initState() {
    super.initState();
    //! Retrasa la inicializacion del reproductor de YouTube
    // ! Lo que hace es que le dice esperate 2 segundos y muestra el video
    // ! Mounted le dice 'si ya esta todo montado', haz eL setstate y coloca en true
    // ! METODO DE OPTIMIZACION | IMPORTANTE
    Future.delayed(const Duration(seconds: 1), () {//? primero se espera a ejecutar los 1 seg
      if (mounted == true) {
        setState(() {
          _showTrailer = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    final fount = ref.read(isdarckProvider).fount;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        //* INFORMACION DE LA MOVIE
        _ElementsInDetails(fount: fount, size: size, movie: widget.movie, textStyle: textStyle),

        _DividerSectionsView(fount: fount),

        //* VIDEO DE LA MOVIE SOLO SI EL TIEMPO PASO
        if(_showTrailer == true)//? solo cuando se cumpla los 1 segundos esto sera true
          VideosFromMovie(movie: widget.movie,),
        
        // * GENERO DE LA MOVIE
        _Genders(widget: widget),

        // * TITULO DE LOS ACTORES
        _TitleCast(textTheme: textStyle, size: size, movieId: widget.movie.id.toString(),),
        
        //* ACTORES DE LA MOVIE
        _ActorsByMovie(movieId: widget.movie.id.toString(), fount: fount,),

        //* TITULO DE SIMILARES
        _PreSimilarMoviesView(size: size, textStyle: textStyle, movieId: widget.movie.id.toString(),),

        //* PELICULAS SIMILARES
        _MoviesSimilars(movieId: widget.movie.id.toString()),

        // const SizedBox(height: 20),
        
      ],
    );
  }
}

// * WIDGET DIVIDER QUE LO USAMOS REPETIDAMENTE EN LA SCREEN
class _DividerSectionsView extends StatelessWidget {
  const _DividerSectionsView({
    required this.fount,
  });

  final bool fount;

  @override
  Widget build(BuildContext context) {
    return Divider(
      endIndent: 10,
      indent: 10,
      thickness: 1,
      color: fount ? Colors.white38 : Colors.black45,
      radius: BorderRadius.circular(50),
    );
  }
}

// * GENEROS DE LA PELICULA
class _Genders extends ConsumerWidget {
  final _MovieDetails widget;
  const _Genders({
    required this.widget,
  });


  @override
  Widget build(BuildContext context, ref) {

    final colors = Theme.of(context).colorScheme;
    final fount = ref.watch(isdarckProvider).fount;

    return Padding(//* GENEROS DE LA MOVIE
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          
          children: widget.movie.genreIds.map(
            (gender) => Container(
              margin: const EdgeInsets.only(right: 10),
              child: Chip(

                label: Text(gender),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                backgroundColor: colors.primary.withOpacity( fount ? 0.3 : 0.9),
              ),
            )
          ).toList(),
        ),
      ),
    );
  }
}

//* ELEMENTOS QUE ESTARAN DENTRO DE LA CAJA DE PELICULA(like overview), TITLE, DETAILS
class _ElementsInDetails extends ConsumerStatefulWidget {
  const _ElementsInDetails({
    required this.fount,
    required this.size,
    required this.movie,
    required this.textStyle,
  });

  final bool fount;
  final Size size;
  final Movie movie;
  final TextTheme textStyle;

  @override
  ConsumerState<_ElementsInDetails> createState() => _ElementsInDetailsState();
}

class _ElementsInDetailsState extends ConsumerState<_ElementsInDetails> {

  var enabledValue = false;

  @override
  void initState() {
    super.initState();

    enabledValue = ref.read(valueInformationMovieProvider(widget.movie.overview.length)).enabled;
  }

  @override
  Widget build(BuildContext context) {
    
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final informationMovieLength = widget.movie.overview.length;
    final linesState = ref.watch(valueInformationMovieProvider(informationMovieLength)).linesInformation;
    final activeStatus = ref.watch(valueInformationMovieProvider(informationMovieLength)).active;

    return Padding(
      padding: const EdgeInsetsGeometry.all(8),
      child: SizedBox(
        width: widget.size.width,
        // ! QUITAMOS EL HEIGHT PARA DECIRLE AL WIDGET QUE COJA TODO1 EL HEIGHT QUE NECESITE 
        // height: size.height * 0.42,
        child: Padding(
          padding: const EdgeInsetsGeometry.only(top: 15, right: 5, left: 5, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: CustomImageMovieView(
                  image: widget.movie.posterPath, 
                  iconErrorWidget: Icons.movie, 
                  size: widget.size,
                  valueSize: 0.17,
                ),
              ),
              
              const SizedBox(width: 10,),
          
              SizedBox( 
                width: widget.size.width * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.movie.title, 
                        style: textStyle.titleLarge,
                      ),
                    ),
                    
                    const SizedBox(height: 10,),
                
                    SizedBox(
                      // height: size.height * 0.17,
                      width: double.infinity,
                      child: Text(
                        widget.movie.overview, 
                        style: textStyle.titleSmall,
                        maxLines: linesState,
                        overflow: TextOverflow.ellipsis,
                        // textAlign: TextAlign.start,
                      ),
                    ),
        
                    SizedBox(height: widget.size.height * 0.01,),
        
                   
                    (enabledValue == true) ? 
                    SizedBox(
                      width: widget.size.width * 0.3,
                      height: widget.size.height * 0.05,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
        
                          ref.read(valueInformationMovieProvider(informationMovieLength).notifier).changeValueInformation(!activeStatus, );
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(5),
                            
                          ),
                          child: Center(
                            child: Text(
                              (activeStatus) ? 'Leer menos' : 'Leer mas....', 
                              style: textStyle.bodySmall?.copyWith( color: Colors.black, fontSize: widget.size.width * 0.035),
                              
                            ),
                          ),
                        ),
                      )
                    ):
                    const SizedBox(),
        
                    SizedBox(height: widget.size.height * 0.01,),
        
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.star_half_rounded, color: Colors.yellow.shade900,),
                          const SizedBox(width: 5,),
                          Text(widget.movie.voteAverage.toStringAsFixed(2), style: TextStyle(color: Colors.yellow.shade900),),
                          
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text(
                            'Estreno: ', 
                            style: textStyle.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold, 
                              fontSize: 15, 
                              color: widget.fount ? Colors.grey : Colors.grey.shade700 
                              ),
                          ),
                          Text(
                            DateFormat('yyyy/MM/dd').format(widget.movie.releaseDate), 
                            style: textStyle.bodySmall?.copyWith(
                              fontSize: 14, 
                              color: widget.fount ? Colors.grey : Colors.grey.shade700 
                            ),
                          ),
                        ],
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

    final fount = ref.read(isdarckProvider).fount;
    // ? POR SI NO HAY PELICULAS NO MOSTRAR ESTE TITULO
    final moviesById = ref.watch(similarMoviesProvider);
    final movies = moviesById[movieId] ?? [];
    
    if (movies.isEmpty){
      return const SizedBox();
    }
    final colors = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 2, left: 10, right: 10, top: 1),
      child: Column(
        children: [
          // * DIVIDER DE SECTIONS
          _DividerSectionsView(fount: fount),

          Row(
            children: [
              
              CustomWidgetForSections(size: size, colors: colors),

              const SizedBox(width: 4,),
              Text(
                'Recomendaciones', 
                style: textStyle.bodyMedium?.copyWith(fontSize: 24),
              ),

              const Spacer(),
              Icon(Icons.recommend, size: size.width * 0.1,),
            ],
          ),
        ],
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
    final size = MediaQuery.of(context).size;
    var totalMoviesSmilisar = moviesSimilars.length;

    if(moviesById[movieId] == null){
      return const CircularProgressIndicator();
    }

    // * SI NO HAY MOVIES SIMILARES 
    if(moviesSimilars.isEmpty){
      return const SizedBox();
    }
    // * CONDICONAL DEPENDIENDO EL TOTAL DE MOVIES
    if(totalMoviesSmilisar >= 9) {
      totalMoviesSmilisar = 9;
    }else{
      totalMoviesSmilisar = 6;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: SizedBox(
        
        height: size.height,
        child: MasonryGridView.count(
          // ? PARA QUE EL MASONRY NO TENGA SU PROPIO SCROLL Y SE INTEGRE EN LA LISTA DE SLIVERS 
          physics: const NeverScrollableScrollPhysics(),
          
          crossAxisCount: 3,
          itemCount: totalMoviesSmilisar,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          
          itemBuilder: (context, index) {
            final movie = moviesSimilars[index];

            return _MovieSimilarView(movie: movie, height: false);
            // if(index %2 == 0){//? si el index es par pues true para que tenga una dimension distinta
            //   return _MovieSimilarView(movie: movie, height: true);
            // }
            // return _MovieSimilarView(movie: movie, height: false);
          },
        ),
      ),
    );
  }
}

// ! ALGO MUY IMPORTANTE USAR EL SIZEDBOX PARA DEFINIR MAXIMOS TAMANOS Y NO EXISTA EL DESVORDAMIENTO
//* WIDGET QUE LE DA DISENO A CADA PELICULA SIMILAR DE LA LISTA DE ARRIBA
class _MovieSimilarView extends StatelessWidget {
  final Movie movie;
  final bool height;
  const _MovieSimilarView({required this.movie, required this.height});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: height ?
      size.height * 0.25
      : 
      size.height * 0.3,
      child: GestureDetector(
        onTap: () {
          //! LA DIRECCION DE LA RUTA CAMBIO PORQUE AHORA ES /HOME, YA NO ES DE DIRECCION RAIZ /
          context.push('/home/0/movie/${movie.id}');
        },
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(5),
          child: SizedBox(
            width: double.infinity,
            height: height ?
            size.height * 0.24
            :
            size.height * 0.29,//* le decimos que tome solo una parte no todo
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CustomImageMovieView(image: movie.posterPath, iconErrorWidget: Icons.movie, size: size, valueSize: 0.3,),

                CustomViewRating(size: size, movie: movie, textStyle: textTheme,)
              ],
            ),
          ),
         
        ),
      ),
    );
  }
}


// * TITULO QUE DICE 'ELENCO'
class _TitleCast extends ConsumerWidget {
  final TextTheme textTheme; 
  final String movieId;
  final Size size;

  const _TitleCast({
    required this.textTheme, 
    required this.movieId, 
    required this.size
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // ? OBTENEMOS EL VALOR QUE DA EL PROVIDER, EL MAP
    final actorsById = ref.watch( actorsByMovieProvider );
    // ? HACEMOS LA TRANSFORMACION DE MAP A LIST, SEGUN EL ID, OBTENEMOS ESOS ACTORS
    // ? LE DECIMOS QUE ME DE TODOS LOS OBJETOS CON ESE ID DE LA MOVIE
    final actors = actorsById[movieId] ?? [];
    final fount = ref.watch(isdarckProvider).fount;
 
    if(actors.isEmpty){
      return const SizedBox();
    }

    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [

        // * DIVIDER
        _DividerSectionsView(fount: fount),

        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 5),
          child: Row(
            children: [
              
              CustomWidgetForSections(size: size, colors: colors),
          
              const SizedBox(width: 5,),
              Text(
                'Elenco',
                style: textTheme.bodyMedium?.copyWith(fontSize: 23),
              ),
          
              const Spacer(),
              
              Icon(Icons.person_2, size: size.width * 0.07,),
            ],
          ),
        ),
      ],
    );
  }
}

//* ACTORES DE LA PELICULA
class _ActorsByMovie extends ConsumerWidget {
  

  final String movieId;
  final bool fount;

  const _ActorsByMovie({
    required this.movieId, 
    required this.fount
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    final size = MediaQuery.of(context).size;

    if(actorsByMovie[movieId]== null){
      return const Center(child: CircularProgressIndicator());
    }

    final actors = actorsByMovie[movieId]!;


    return SizedBox(
      height: size.height * 0.45,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        addAutomaticKeepAlives: false, //* PARA QUE NO GUARDE EL ESTADO DE LOS WIDGETS SI SE HACE SCROLL SE DESTRUYE
        itemBuilder: (context, index) {
          final actor = actors[index];

          return _ActorView(actor: actor, fount: fount,);
        },
      ),
    );
  }
}

//* CAJA DE CADA ACTOR (DISENO) Y SU INFORMACION
class _ActorView extends StatelessWidget {

  final Actor actor;
  final bool fount;
  const _ActorView({
    required this.actor, 
    required this.fount
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(//? DEFINE EL TAMANO DE TODA LA 'TARJETA' CON IMAGEN NOMBRE
      width: size.width * 0.33,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //* Foto de el Actor
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: CustomImageMovieView(
                image: actor.profilePath, 
                iconErrorWidget: Icons.person, 
                size: size, 
                valueSize: 0.27
              ),
            ),

            //* Nombre de el Actor
            const SizedBox(height: 5,),
            // const Spacer(),
            Text(
              actor.name, 
              maxLines: 1,
            ),
      
            //* el papel que interpretaron 
            Text(
              actor.character ?? '', 
              maxLines: 1,
              style: const TextStyle(
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
class _CustomSliverAppBar extends ConsumerStatefulWidget {

  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  ConsumerState<_CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends ConsumerState<_CustomSliverAppBar> {


  //! PARA EL USO DE SONIDSO ES NECESARIO EL PLUGIN AUDIOPLAYERS
  //! SE REQUIERE UN STATEFUL O CONSUMERFUL, ADEMAS DE MODIFICAR EL ANDROIDMANIFEST
  //! UNA FUNCION FUTURA Y TERMINAR EL VALOR CON EL DISPOSE 
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> reproducirSonido() async{
    await _audioPlayer.setVolume(0.3);//* REGULAR EL VOLUMEN 1 MAXIMO
    await _audioPlayer.play(AssetSource('sounds/favorites_03.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;//* para saber las dimensiones del dispositivo
    // final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(movie.id));
    final isDarck = ref.watch(isdarckProvider).fount;

    final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(widget.movie.id));

    final colors = Theme.of(context).colorScheme;

    final textTheme = Theme.of(context).textTheme;

    //! toma el color blacno o negro dependiendo del contexto del theme
    //final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    
    return SliverAppBar(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,

      
      leading: IconButton(
        onPressed: (){
          //* Ligera vibracion
          HapticFeedback.heavyImpact();

          //* Es distinto de como apilar y desapilar con el push y pop, este coloca y ya no apila
          context.go('/');//es como teletransporstarse hacia otra pantalla, en lugar de ir una por una
        }, 
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,)
      ),

      actions: [//! PARA QUE FUNCIONE LA PARTE DE FAVORITOS, USA LA BASE DE DATOS LOCAL

          //* BOTON DE COMPARTIR MOVIE
          CustomButton(
            movie: widget.movie, 
            isDarck: isDarck,
            iconActive: Icons.share,
            iconNotActive: Icons.share_outlined,
            onPressed: () {

              HapticFeedback.lightImpact();

              SharePlugin.shareLink(
                'https://moviedo.up.railway.app/home/0/movie/${widget.movie.id}', 
                'Mira esta Pelicula'
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, color: Colors.white,)
              ],
            ),
          ),

          // * BOTON DE FAVORITOS
          CustomButton(//* BOBTON A PARTE PERSONALIZADO
            movie: widget.movie, 
            isDarck: isDarck,
            iconActive: Icons.favorite_rounded,
            iconNotActive: Icons.favorite_border_rounded,
            onPressed: () async{

              // ? PARA DAR UNA PEQUENA VIBRACION AL PULSAR
              HapticFeedback.lightImpact();

              await ref.read(favoriteMoviesProvider.notifier).toggleFavoriteMovie(widget.movie);
              ref.invalidate(isFavoriteMovieProvider(widget.movie.id));
              final isFav = isFavoriteFuture.value ?? false;//* Obtenemos el valor
              
              if(isFav == true){//* Significa que es un favorito, si lo pulsa de debe mostrar mensaje de se quito
                // ignore: use_build_context_synchronously
                CustomSnackBar.snackBar(context, isDarck, 'Se quito de tus Favoritas', textTheme);
                
              }else{
                // ignore: use_build_context_synchronously
                CustomSnackBar.snackBar(context, isDarck, 'Se agrego a tus Favoritas', textTheme);
              }
              // * SONIDO AL PULSAR
              reproducirSonido();
            },
            child:  isFavoriteFuture.when(
              data: (isFavorite) => isFavorite == true ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon( Icons.favorite_rounded, color: colors.primary,),
                ],
              )
              :
              const Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon( Icons.favorite_border_rounded, color: Colors.white,),
                ],
              ),
              error: (_, _) => throw Exception("Error al cargar el estado de favoritos"), 
              loading: () => const Center(
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(strokeWidth: 2,)
                )
              ),
            )
          )      
      ],

      expandedHeight: size.height * 0.7,

      // ? IMAGEN
      flexibleSpace: FlexibleSpaceBar(
        //* contenido
        background: _ContentSilverAppBar(movie: widget.movie),

        //! ESTO ES PARA QEU EL GRADIENTE PARA QUE SE VEA EL TITULO EN PELICUALS CON FONDO BLANCO
        //! SE MUEVA INCLUSO SI BAJO LA PANTALLA  
        titlePadding: const EdgeInsets.only(bottom: 0),
        title:  const _CustomGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.8, 1],
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


  @override
  Widget build(BuildContext context) {
    //final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final size = MediaQuery.of(context).size;

    return Stack(//* el fondo
      children: [

        Expanded(
          child: SizedBox.expand(
           
            child: CustomImageMovieView(
              image: movie.posterPath, 
              iconErrorWidget: Icons.movie, 
              size: size,
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
        const _CustomGradient(
          begin: Alignment.topLeft, 
          stops: [0.0, 0.4],
          colors: [Colors.black, Colors.transparent]
        ),

        //*GRADIENTE DE EL BOTON DE FAVORITOS
        const _CustomGradient(
          begin: Alignment.topRight, 
          end: Alignment.bottomCenter, 
          stops: [0.0, 0.2],
          colors: [Colors.black, Colors.transparent]
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




