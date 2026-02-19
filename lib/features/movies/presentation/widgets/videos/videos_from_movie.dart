import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ! EXISTE UN PROBLEMA QUE NO SE PUEDE CONTROLAR, DEBIDO A LAS POLITICAS DE YT QUE RECIENTEMENTE
// ! ACTUALIZARON, NO DE PUEDE REPRODUCIR LOS TRAILERS, NO ES UN PROBLEMA DE LA APP, SINO DE LAS POLITICAS DE YT

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
        _YouTubeVideoPlayer(videos: videos,)
      ],
    );
  }
}

//! El que forma el video, es stateful porque necesito un controller
class _YouTubeVideoPlayer extends StatefulWidget {
  final List<Video> videos;

  const _YouTubeVideoPlayer({required this.videos});

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
  YoutubePlayerController? _controller;
  bool _showPlayer = false;
  bool _hasError = false;
  int _errorCode = 0;
  int _currentIndex = 0; 

  
  Video get _currentVideo => widget.videos[_currentIndex];

  void _initAndPlay() {
    if (_controller != null) {
      setState(() => _showPlayer = true);
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: _currentVideo.youtubeKey, 
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        hideControls: false,
      ),
    );

    _controller!.addListener(_handleControllerChange);
    setState(() => _showPlayer = true);
  }

  void _handleControllerChange() {
    final controller = _controller;
    if (controller == null) return;

    final errorCode = controller.value.errorCode;
    if (errorCode != 0 && !_hasError) {
      if (!mounted) return;
      _tryNextVideo(errorCode); 
    }
  }


  void _tryNextVideo(int errorCode) {
    final nextIndex = _currentIndex + 1;

    if (nextIndex < widget.videos.length) {
      // hay más videos, intenta con el siguiente
      _controller?.removeListener(_handleControllerChange);
      _controller = null;

      setState(() {
        _currentIndex = nextIndex;
        _hasError = false;
        _errorCode = 0;
        _showPlayer = false;
      });

      // pequeño delay para que el widget se reconstruya
      Future.delayed(const Duration(milliseconds: 300), _initAndPlay);
    } else {
      // se agotaron todos los videos
      setState(() {
        _hasError = true;
        _errorCode = errorCode;
        _showPlayer = false;
      });
    }
  }

  Future<void> _openInYoutube() async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=${_currentVideo.youtubeKey}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleControllerChange);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = YoutubePlayer.getThumbnail(
      videoId: _currentVideo.youtubeKey, 
      quality: ThumbnailQuality.medium,
    );
    final hasError = _hasError || (_controller?.value.hasError ?? false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _showPlayer && _controller != null && !hasError
                ? YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(isExpanded: true),
                      RemainingDuration(),
                      const PlaybackSpeedButton(),
                    ],
                  )
                : GestureDetector(
                    onTap: hasError ? null : _initAndPlay,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(thumbnailUrl, fit: BoxFit.cover),
                        Container(
                          color: Colors.black26,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                hasError ? Icons.error_outline : Icons.play_circle_fill,
                                size: 64,
                                color: Colors.white,
                              ),
                              if (hasError) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'No se puede reproducir (Error $_errorCode)',
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                TextButton(
                                  onPressed: _openInYoutube,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Ver en YouTube'),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}