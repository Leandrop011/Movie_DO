import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/config/plugins/redirect_yt_plugin.dart';
import 'package:movies_app/features/movies/domain/entities/index.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/index.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
class _YouTubeVideoPlayer extends StatefulWidget {

  final String youtubeId;
  final String name;
  final Movie movie;

  const _YouTubeVideoPlayer({ required this.youtubeId, required this.name, required this.movie });

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {

  // ? EL CONTROLLER Y BOOL QUE SE INICIALIZARA DESPUES
  late bool start = false;

  int _errorCode = 0;
  bool _hasError = false;
  late final YoutubePlayerController _controller;  

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
        
        //? el listener esta constantemente escuchando los cambios
        // ! CON CONTROLLERS ES MEJOR CREARLO Y MODIFICARLO CON EL ADDLISTENER
        // ! DENTRO DEL INITSTATE PORQUE SOLO SE LO CREA CUANDO NACE EL WIDGET
        // ! Y ASI EVITAMOS CREARLO VARIAS VECES 
      )..addListener((){
        // * EL ADDLISTENER ES EL QUE CAMBIARA Y REDIBUJARA EL WIDGET CADA QUE 
        // * EL ESTADO DEL CONTROLLER CAMBIE, ES EL QUE ESTA PENDIENTE DE LOS CAMBIOS 
        // * DEL CONTROLLER ASI QUE CON AYUDA DEL SETSTATE PODEMOS QUITAR O CAMBIAR 
        // * EL VIDEO POR OTRO WIDGET
        final value = _controller.value;
        final newErrorCode = value.errorCode;
        final newHasError = value.hasError;

        if (!mounted) return;

        if (_errorCode != newErrorCode || _hasError != newHasError) {
          setState(() {
            _errorCode = newErrorCode;
            _hasError = newHasError;
          });
        }
      });
  }


  @override
  void dispose() {
    //* limpiar al salir del widget
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    // ? ESTO SE MOSTRARA CUANDO EL LISTTENER DEL CONTROLLER DETECTE EN SU CAMBIO 
    // ? QUE EXISTE UN ERROR PUES REDIBUJA ESTO
    if(_hasError){
      return _FailledVideoView(
        size: size, 
        youtubeIdVideo: widget.youtubeId
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * NOMBRE DEL VIDEO EN YT
          Padding(
            padding: const EdgeInsets.only(left: 3, bottom: 5),
            child: Text(widget.name),
          ),
          // * VIDEO EN YT CON CONTROLLER 
          (start == true) ?
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          )
          :
          Center(
            child: ClipRRect(
              
              borderRadius: BorderRadiusGeometry.circular(20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    start = true;
                  });
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
                      
                        widget.movie.posterPath,
                        fit: BoxFit.fill,
                      ),
                  
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

// ? WIDGET QUE SE MUESTRA SI EXISTE UN ERROR CON EL VIDEO
class _FailledVideoView extends StatelessWidget {
  
  final String youtubeIdVideo;
  final Size size;

  const _FailledVideoView({
    required this.size, 
    required this.youtubeIdVideo,
  });


  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () => RedirectYtPlugin.openYoutube('https://www.youtube.com/watch?v=$youtubeIdVideo'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1,
                      color: Colors.white38
                    )
                  ),
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: Image.asset(
                        width: double.infinity,
                        height: double.infinity,
                        'assets/loaders/loader_wrong.png',
                        fit: BoxFit.fill,
                      ),
                  
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 51, 109, 210),
                      ),
                      child: Center(
                        child: Text(
                          'Continuar a YouTube',
                          style: textTheme.titleSmall?.copyWith(color: Colors.black),
                         )
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
