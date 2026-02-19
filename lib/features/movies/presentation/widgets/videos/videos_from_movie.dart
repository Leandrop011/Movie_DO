import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/index.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ! EXISTE UN PROBLEMA QUE NO SE PUEDE CONTROLAR, DEBIDO A LAS POLITICAS DE YT QUE RECIENTEMENTE
// ! ACTUALIZARON, NO DE PUEDE REPRODUCIR LOS TRAILERS, NO ES UN PROBLEMA DE LA APP, SINO DE LAS POLITICAS DE YT

class VideosFromMovie extends ConsumerWidget {

  final int movieId;

  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    final moviesFromVideo = ref.watch(videosFromMovieProvider(movieId));

    //* Para tener los 3 estados de la DATA
    //*Data
    //*Error
    //*Cargando
    return moviesFromVideo.when(
      data: ( videos ) => _VideosList( videos: videos ),
      error: (_ , _) => const Center(child: Text('No se pudo cargar el video :(') ), 
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

//! Estructura de lo que se mostrara
class _VideosList extends StatelessWidget {

  final List<Video> videos;

  const _VideosList({required this.videos });

  @override
  Widget build(BuildContext context) {

    //* Nada que mostrar
    if ( videos.isEmpty ) {
      return const SizedBox(); 
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ignore: prefer_const_constructors
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text('Video', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),
        
        // * Aunque tengo varios videos, sólo quiero mostrar el primero
        // * SOLO MANDAMOS EL PRIMER VIDEO DE LA LIST QUE RECIBIMOS, MANDAMOS SU YOUTUBE KEY
        _YouTubeVideoPlayer(youtubeId: videos.first.youtubeKey, name: videos.first.name )
        
        //* Si se desean mostrar todos los videos
        // ...videos.map(
        //   (video) => _YouTubeVideoPlayer(youtubeId: videos.first.youtubeKey, name: video.name)
        // ).toList()
      ],
    );
  }
}

//! El que forma el video, es stateful porque necesito un controller
class _YouTubeVideoPlayer extends StatefulWidget {

  final String youtubeId;
  final String name;

  const _YouTubeVideoPlayer({ required this.youtubeId, required this.name });

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {

  // ? EL CONTROLLER QUE SE INICIALIZARA DESPUES
  late YoutubePlayerController _controller;  

  @override
  void initState() {
    super.initState();
    
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true, //? para mostrar la miniatura
        showLiveFullscreenButton: false, //? para el boton de transmision en vivo
        mute: false, //? para determinar si comienza o no con sonido
        autoPlay: false, //? para determinar si se coloca play automaticamente o no
        disableDragSeek: false, //? para determinar si el usuario puede arrastrar la barra
        loop: false, //? para determinar si se repite el video 
        isLive: false, //? inidica si es o no una transmision en vivo
        forceHD: false, //? para determinar si coloca la maxima calidad o se ajusta a su wifi
        enableCaption: false, //? para los subtitulos
        hideControls: false, //?Para activar o no los controles
      ),
      //? el listener esta constantemente escuchando los cambios(similar al setstate) 
    );
  }



  @override
  void dispose() {
    //* limpiar al salir del widget
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * NOMBRE DEL VIDEO EN YT
          Text(widget.name),
          // * VIDEO EN YT CON CONTROLLER 
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
        ],
      )
    );
  }
}