import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/index.dart';
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
      error: (_ , _) => const Center(child: Text('No se pudo cargar pelÃ­culas similares') ), 
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
        //* Aunque tengo varios videos, sÃ³lo quiero mostrar el primero
        _YouTubeVideoPlayer(youtubeId: videos.first.youtubeKey, name: videos.first.name )
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

  YoutubePlayerController? _controller;
  bool _showPlayer = false;

  @override
  void initState() {
    super.initState();
  }

  // ! OPTIMIZACION MEDIANTE UNA VARIABLE BOOLEANA Y UN METODO CON SETSTATE
  // ! SE CAMBIA UNA MINIATURA POR EL VIDEO Y ASI SE OPTIMIZA
  // ! EN LUGAR DE CARGAR TODO1 EL VIDEO, CARGA LA IMAGEN NOMAS

  // ? METODO QUE AL HACER ONTAP EN LA MINIATURA
  // ? CAMBIA EL ESTADO ESE BOOL Y MUESTRA EL VIDEO, ADEMAS DE INICIALIZAR EL CONTROLLER
  void _initAndPlay() {
    if (_controller != null) {
      setState(() => _showPlayer = true);
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true, //? para mostrar la miniatura
        showLiveFullscreenButton: false, //? para el boton de transmision en vivo
        mute: false, //? para determinar si comienza o no con sonido
        autoPlay: true, //? reproducir cuando se crea
        disableDragSeek: false, //? para determinar si el usuario puede arrastrar la barra
        loop: false, //? para determinar si se repite el video 
        isLive: false, //? inidica si es o no una transmision en vivo
        forceHD: false, //? para determinar si coloca la maxima calidad o se ajusta a su wifi
        enableCaption: false, //? para los subtitulos
        hideControls: false, //?Para activar o no los controles
      ),
    );

    setState(() => _showPlayer = true);
  }



  @override
  void dispose() {
    //* limpiar al salir del widget
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = YoutubePlayer.getThumbnail(
      videoId: widget.youtubeId,
      quality: ThumbnailQuality.high,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(widget.name),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _showPlayer && _controller != null
                // ? Muestra el video
                ? YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(isExpanded: true),
                      RemainingDuration(),
                      const PlaybackSpeedButton(), // opcional
                    ],
                  )
                  // ? MUESTRA SOLO LA MINIATURA
                : GestureDetector(
                    onTap: _initAndPlay,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black26,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.play_circle_fill,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
              ),
          ),
        ],
      )
    );
  }
}
