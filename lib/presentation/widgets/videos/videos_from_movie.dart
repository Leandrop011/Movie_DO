import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:movies_app/domain/entities/video.dart';
import 'package:movies_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//* PROVIDER AQUI MISMO, OBTENEMOS LOS VIDEO QUE TIENE DE ESA MOVIE
final FutureProviderFamily<List<Video>, int> videosFromMovieProvider  = FutureProvider.family(
  (ref, int movieId){
    final movieRepository = ref.watch(movieRepositoryProvider);
    return movieRepository.getYoutubeVideosById(movieId);
  }
);

class VideosFromMovie extends ConsumerWidget {
  
  final int movieId;
  
  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final moviesFromVideo = ref.watch(videosFromMovieProvider(movieId));
    //!EL FAMILY NOS PERMITE TENER LOS 3 ESTADOS
    return moviesFromVideo.when(
      data: (videos) => _VideosList(videos: videos,), 
      error: (_, __) => Center(child: Text('No se pudo cargar peliculas similares'),), 
      loading: () => Center(child: CircularProgressIndicator(strokeWidth: 2,),)
    );
  }
}

class _VideosList extends StatelessWidget {
  final List<Video> videos;
  const _VideosList({
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {

    if(videos.isEmpty){
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('Trailer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),

        //* ESTO ES LA FORMA DE TRAER EL VIDEO DE YOUTUBE
        //* SOLO NOS TRAE EL PRIMER ELEMENTO QUE ENCUENTRE POR EL FIRST
        _YoutubeVideoPlayer(youtubeId: videos.first.youtubeKey, name: videos.first.name,)
      ],
    );
  }
}

class _YoutubeVideoPlayer extends StatefulWidget {
  final String youtubeId;
  final String name;
  const _YoutubeVideoPlayer({
    required this.youtubeId, 
    required this.name
  });

  @override
  State<_YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<_YoutubeVideoPlayer> {

  late YoutubePlayerController _controller;//* PARA USAR ESTE CONTROLLER, SE NECESITA INSTALAR UNA DEPENDENCIA youtube_player_flutter
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(//! CONTROLADOR DEL WIDGET YOUTUBE
      initialVideoId: widget.youtubeId,
      flags: YoutubePlayerFlags(
        hideThumbnail: true,
       showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        hideControls: false
      )
    );
  }

  @override
  void dispose() {
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
          Text(widget.name),
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(controller: _controller)
            )
          )
        ],
      ),
      
    );
  }
}