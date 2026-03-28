import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/config/plugins/redirect_yt_plugin.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/movies.dart';
import 'package:movies_app/features/movies/presentation/providers/video/video_start_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoMovieScreen extends ConsumerStatefulWidget {

  final ColorScheme colors;
  final String youtubeId;
  final String movieId;

  const VideoMovieScreen({
    super.key, 
    required this.colors, 
    required this.youtubeId, 
    required this.movieId,
  });

  @override
  ConsumerState<VideoMovieScreen> createState() => _VideoMovieScreenState();
}

class _VideoMovieScreenState extends ConsumerState<VideoMovieScreen> {
  int errorCode = 0;
  bool hasError = false;
  late final YoutubePlayerController controller;  

  //? ORIENTACION APENAS ENTRAR
  @override
  void initState() {
    super.initState();


    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
      ]
    );

    controller = YoutubePlayerController(
        initialVideoId: widget.youtubeId,
        flags: const YoutubePlayerFlags(
          hideThumbnail: false, //? para mostrar la miniatura
          showLiveFullscreenButton: false, //? para el boton de transmision en vivo
          mute: false, //? para determinar si comienza o no con mute 
          autoPlay: true, //? para determinar si se coloca play automaticamente o no
          disableDragSeek: false, //? para determinar si el usuario puede arrastrar la barra
          loop: false, //? para determinar si se repite el video 
          isLive: false, //? inidica si es o no una transmision en vivo
          forceHD: false, //? para determinar si coloca la maxima calidad o se ajusta a su wifi
          enableCaption: false, //? para los subtitulos
          hideControls: false, //?Para activar o no los controles, false activos, true inactivos
          
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
        final value = controller.value;
        final newErrorCode = value.errorCode;
        final newHasError = value.hasError;

        if (!mounted) return;

        // * SI YA INICIO EL VIDEO COLOCAMOS EL VALOR BOOL DE INICIO DEL VIDEO EN FALSE
        // * O SI EL CONTROLLER ESTA LISTO O SI EL BUFFERED ES 0 O SI EL ESTADO DEL CONTROLLER ES DESCONOCIDO
        if(value.hasPlayed || value.isReady || (value.buffered == 0) || (value.playerState == PlayerState.unknown)){
          ref.read(videoStartProvider.notifier).changeStart(value: false);
        }

        if (errorCode != newErrorCode || hasError != newHasError) {
          setState(() {
            errorCode = newErrorCode;
            hasError = newHasError;
          });
        }
      });

  }

  //? ORIENTACION APENAS SALIR, EL DISPOSE EJECUTA CODIGO AL DESTRUIR EL WIDGET
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    final String? titleMovie = movie?.title;
    final textTheme = Theme.of(context).textTheme;
    // final colors = Theme.of(context).colorScheme; 

    if(hasError){
      return _FailledVideoView(
        size: size, 
        youtubeIdVideo: widget.youtubeId
      );
    }

    return Scaffold(
    
      body: Center(
        child: YoutubePlayer(
          
          progressIndicatorColor: widget.colors.primary,
          controller: controller,
          // ? LOS CONTROLES QUE ESTARAN DISPONIBLES EN EL VIDEO
          bottomActions: [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
            PlaybackSpeedButton(),
            SizedBox(width: size.width * 0.03,),
            RemainingDuration(),

          ],
          
          topActions: [
            // * IconButton que regresa, cada que pulse la pantalla
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.065, left: size.width * 0.02),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {

                      HapticFeedback.heavyImpact();
                      
                      // * PROVIDER QUE COLOCA EN FALSE LA VARIABLE BOOL DE SI INICIO O NO EL VIDEO
                      ref.read(videoStartProvider.notifier).changeStart(value: false);
                      
                      context.pop();
                      
                    }, 
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    titleMovie ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),

          ],
          showVideoProgressIndicator: true,
        ),
      ),
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
