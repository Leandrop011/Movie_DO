import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:movies_app/domain/entities/video.dart';
import 'package:movies_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:url_launcher/url_launcher.dart';

//! IMPLEMENTAMOS ESTE CODE CON ESE PLUGIN PORQUE LA ESTRUCTURA QUE TENEMOS
//! CON LOS SLIVERS NO ES COMPATIBLE CON EL PLUGIN QUE USA FERNANDO
//* PROVIDER AQUI MISMO, OBTENEMOS LOS VIDEO QUE TIENE DE ESA MOVIE
final FutureProviderFamily<List<Video>, int> videosFromMovieProvider = FutureProvider.family(
  (ref, int movieId) {
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
    
    return moviesFromVideo.when(
      data: (videos) {
        if (videos.isEmpty) {
          return const SizedBox();
        }
        return _VideosList(videos: videos);
      }, 
      error: (_, __) => const SizedBox(), 
      loading: () => const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2)
        ),
      )
    );
  }
}

class _VideosList extends StatelessWidget {
  final List<Video> videos;
  
  const _VideosList({required this.videos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'VIDEO', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 10),
          _YoutubeVideoPlayer(
            youtubeId: videos.first.youtubeKey, 
            name: videos.first.name
          ),
        ],
      ),
    );
  }
}

class _YoutubeVideoPlayer extends StatelessWidget {
  final String youtubeId;
  final String name;
  
  const _YoutubeVideoPlayer({
    required this.youtubeId, 
    required this.name
  });

  Future<void> _openYoutube(BuildContext context) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$youtubeId');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir el video'))
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al abrir YouTube'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          GestureDetector(
            onTap: () => _openYoutube(context),
            child: Container(
              width: size.width - 20,
              height: (size.width - 20) * 9 / 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Thumbnail de YouTube
                    Image.network(
                      'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Si falla maxresdefault, intenta con hqdefault
                        return Image.network(
                          'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    // Overlay oscuro
                    Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    // Botón de play
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 5, 92, 243),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}