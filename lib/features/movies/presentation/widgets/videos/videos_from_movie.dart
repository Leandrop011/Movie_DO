import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
import 'package:movies_app/features/movies/presentation/widgets/widgets.dart';

// ! EXISTE UN PROBLEMA QUE NO SE PUEDE CONTROLAR, DEBIDO A LAS POLITICAS DE YT QUE RECIENTEMENTE
// ! ACTUALIZARON, NO DE PUEDE REPRODUCIR LOS TRAILERS, NO ES UN PROBLEMA DE LA APP, SINO DE LAS POLITICAS DE YT

class VideosFromMovie extends ConsumerWidget {

  final Movie movie;

  const VideosFromMovie({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    final moviesFromVideo = ref.watch(videosFromMovieProvider(movie.id));

    //* Para tener los 3 estados de la DATA
    //*Data
    //*Error
    //*Cargando
    return moviesFromVideo.when(
      data: ( videos ) => _VideosList( videos: videos , movie: movie,),
      error: (_ , _) => const Center(child: Text('No se pudo cargar el video :(') ), 
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

//! Estructura de lo que se mostrara
class _VideosList extends StatelessWidget {

  final List<Video> videos;
  final Movie movie;

  const _VideosList({required this.videos, required this.movie });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    //* Nada que mostrar
    if ( videos.isEmpty ) {
      return const SizedBox(); 
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const SizedBox(width: 5,),
              CustomWidgetForSections(size: size, colors: colors),
              const SizedBox(width: 5,),
              const Icon(Icons.movie),
              const SizedBox(width: 5,),
              const Text('Video', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        
        // * Aunque tengo varios videos, s�lo quiero mostrar el primero
        // * SOLO MANDAMOS EL PRIMER VIDEO DE LA LIST QUE RECIBIMOS, MANDAMOS SU YOUTUBE KEY
        _YouTubeVideoPlayer(youtubeId: videos.first.youtubeKey, name: videos.first.name, movie: movie, )
        
        //* Si se desean mostrar todos los videos
        // ...videos.map(
        //   (video) => _YouTubeVideoPlayer(youtubeId: videos.first.youtubeKey, name: video.name)
        // ).toList()
      ],
    );
  }
}

//! El que forma el video, es stateful porque necesito un controller
class _YouTubeVideoPlayer extends ConsumerWidget {

  final String youtubeId;
  final String name;
  final Movie movie;

  const _YouTubeVideoPlayer({ required this.youtubeId, required this.name, required this.movie });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final start = ref.watch(videoStartProvider).start;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * NOMBRE DEL VIDEO EN YT
          Padding(
            padding: const EdgeInsets.only(left: 3, bottom: 5),
            child: Text(
              name,
              style: textTheme.titleMedium?.copyWith(fontSize: 15),
            ),
          ),
          // * MINIATURA DEL VIDEO QUE NAVEGA A LA REPRODUCCION DEL VIDEO
          Center(
            child: ClipRRect(
              
              borderRadius: BorderRadiusGeometry.circular(20),
              child: GestureDetector(
                onTap: (){

                  // * COLOCAMOS EL VALOR BOOL DE SI INICIO EL VIDEO EN TRUE
                  ref.read(videoStartProvider.notifier).changeStart();

                  
                  // * Navegar a otra screen donde reproduzca el video, mandamos el youtubeId por la ruta
                  context.push('/video_movie/${movie.id}/$youtubeId'); 

                },
                child: SizedBox(
                  height: size.height * 0.3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        // ? LE DECIMOS QUE OCUPE TODO1 EL ESPACIO QUE TIENE
                        width: double.infinity,
                        height: double.infinity,
                      
                        movie.posterPath,
                        fit: BoxFit.fill,
                      ),
                  
                      (start == true) ?
                      Container(
                        width: size.width * 0.45,
                        height: size.height * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black54,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(strokeWidth: 4, ),
                            const SizedBox(height: 5,),
                            
                              Center(
                                child: Text(
                                  'Cargando....',
                                  style: textTheme.bodySmall?.copyWith(color: colors.primary, fontSize: 15),
                                ),
                              ),
                            
                          ],
                        ),
                      )
                      :
                      Icon(
                        Icons.play_arrow_rounded, 
                        color: Colors.white, 
                        size: size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

