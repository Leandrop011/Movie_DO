
//* APPBAR
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/config.dart';
import '../../../../features.dart';

class CustomSliverAppBar extends ConsumerStatefulWidget {

  final Movie movie;

  const CustomSliverAppBar({super.key, required this.movie});

  @override
  ConsumerState<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends ConsumerState<CustomSliverAppBar> {


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
        title:  const CustomGradient(
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

//* CONTENIDO DE LA APPBAR, MUESTRA LA PELICULA
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

        SizedBox.expand(
          child: CustomImageMovieView(
            image: movie.posterPath,
            iconErrorWidget: Icons.movie,
            size: size,
          ),
        ),

        //*GRADIENTE DE LA FLECHA DE REGRESO
        const CustomGradient(
          begin: Alignment.topLeft, 
          stops: [0.0, 0.4],
          colors: [Colors.black, Colors.transparent]
        ),

        //*GRADIENTE DE EL BOTON DE FAVORITOS
        const CustomGradient(
          begin: Alignment.topRight, 
          end: Alignment.bottomCenter, 
          stops: [0.0, 0.2],
          colors: [Colors.black, Colors.transparent]
        ),
        
      ],
    );
  }
}

