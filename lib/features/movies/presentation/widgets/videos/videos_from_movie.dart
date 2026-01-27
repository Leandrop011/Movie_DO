import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:movies_app/features/movies/domain/entities/video.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/movies_repository_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


final FutureProviderFamily<List<Video>, int> videosFromMovieProvider = FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});

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
      error: (_ , __) => const Center(child: Text('No se pudo cargar películas similares') ), 
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
    final style = Theme.of(context).textTheme;

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
          child: Text('Video', style: style.titleMedium,),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(videos.first.name, style: style.titleSmall,),
        ),
        //* Aunque tengo varios videos, sólo quiero mostrar el primero
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
    // )..addListener((){//* el '..' es para concatenar metodos al _controller
    //   //* detecta cuando entra/sale de la pantalla completa
    //   if (_controller.value.isFullScreen) {
    //     //* Modo horizontal
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.landscapeLeft,
    //       DeviceOrientation.landscapeRight,
    //     ]);
    //   }
    //   else{
    //     //* Modo Vertical
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.portraitUp,
    //       DeviceOrientation.portraitDown,
    //     ]);
    //   }
    // });
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
          // Text(widget.name),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
              RemainingDuration(),
              const PlaybackSpeedButton(), // opcional
              
            ],
          ),
        ],
      )
    );
  }
}