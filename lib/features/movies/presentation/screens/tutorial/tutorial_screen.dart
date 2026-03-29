import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/tutorial_movies_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ? COMO SE VERA CADA SLIDE
class SlideInfo {
  final String title;
  final String caption;
  final String image;

  SlideInfo({
    required this.title, 
    required this.caption, 
    required this.image
  });
}

// ? LA LISTA DE SLIDES PARA EL TUTORIAL QUE SE CREARAN
final slidesTutorial = <SlideInfo>[
  SlideInfo(title: 'Bienvenido a\nMovie DO', caption: 'Tu guía definitiva para explorar el séptimo arte. Encuentra información detallada sobre tus películas favoritas en un solo lugar.', image: 'assets/tutorial/slide_tutorial_01.png'),
  SlideInfo(title: 'Descubre lo que sigue', caption: 'Explora estrenos, clásicos y recomendaciones personalizadas según tu gusto.', image: 'assets/tutorial/slide_tutorial_02.png'),
  SlideInfo(title: 'Listo para empezar', caption: '¡Tu próxima película favorita te está esperando! Sumérgete en el mundo del cine ahora mismo.', image: 'assets/tutorial/slide_tutorial_03.png'),
];

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {

  final PageController pageViewController = PageController();
  bool endReached = false;

  @override
  void initState() {
    super.initState();
    
    // ? LISTENER QUE ESTARA ESCUCHANDO LOS CAMBIOS DEL CONTROLLER
    pageViewController.addListener((){
      // * PAGE EN LA QUE SE ENCUENTRA
      final page = pageViewController.page ?? 0;

      // * SI ENDREACHED ES FALSE Y LA PAGINA ES MAYOR QUE O IGUAL A 1.5 PUES 
      // * HACE SETSTATE DE ENDREACHED
      if(!endReached && page >= (slidesTutorial.length - 1.5)){
        setState(() {
          endReached = true;
        });
      }

      // * POR SI EL USUARIO REGRESA A LAS ANTERIORES SLIDES, SE DECIDE QUITAR EL BOTON
      if(page <= (slidesTutorial.length - 1.5)){
        setState(() {
          endReached = false;
        });
      }
    });

  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final tutorialValue = ref.watch(tutorialMoviesProvider).didExecuted;
    final colorTheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ZoomInDown(
        child: SafeArea(
          child: Stack(
            children: [
              
              // ? IMAGEN Y TEXTO EXPLICATIVO
              PageView(
                physics: BouncingScrollPhysics(),
                controller: pageViewController,
                children: slidesTutorial.map(
                  (slide) => _SlideView(
                    title: slide.title, 
                    caption: slide.caption, 
                    image: slide.image,
                  ),
                ).toList(),
              ),
          
              // ? BOTON DE 'SALTAR' POR SI EL USUARIO NO DESEA VER EL TUTORIAL
              Positioned(
                top: 10,
                right: 10,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10)
                    )
                  ),
                  onPressed: (){
                    ref.read(tutorialMoviesProvider.notifier).setValueTutorial(!tutorialValue);
                  }, 
                  child: Text(
                    'Saltar', 
                    style: textTheme.bodySmall,
                  ),
                )
              ),
          
          
              // ? BOTON QUE SE DIBUJA SOLO CUANDO ESTE APUNTO DE LLEGAR A LA ULTIMA VIEW 
              // ? DEL PAGE VIEW
              endReached ?
              Positioned(
                bottom: 20,
                right: 10,
          
                child: SlideInRight(
                  duration: Duration(seconds: 1),
                  curve: Curves.decelerate,
                  child: FilledButton(

                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadiusGeometry.circular(10),
                      )
                    ),

                    onPressed: (){
                  
                      ref.read(tutorialMoviesProvider.notifier).setValueTutorial(!tutorialValue);
                    
                    }, 
                    child: Text('Comenzar!')
                  ),
                ),
          
              )
              :
              SizedBox(),
          
              // ? PUNTITOS QUE MUESTRAN LA POSICION DE CADA SLIDE
              Positioned(
                bottom: size.height * 0.14,
                left: size.width * 0.44,
                child: SmoothPageIndicator(
                  controller: pageViewController, 
                  count: slidesTutorial.length,
                  
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    type: WormType.thin,
          
                    activeDotColor: colorTheme.primary,
                    dotColor: colorTheme.secondary,
                  ),
                )
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {

  final String title;
  final String caption;
  final String image;

  const _SlideView({ 
    required this.title, 
    required this.caption, 
    required this.image,
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.55,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 57, 56, 56),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 0.5,
            color: const Color.fromARGB(255, 94, 94, 94),
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * TITULO
              Text(
                title,
                style: textTheme. titleLarge?.copyWith(fontSize: 25),
              ),

              SizedBox(height: 10,),
          
              // * IMAGEN
              Center(
                child: SizedBox(
                  width: size.width * 0.7,
                  height: size.height * 0.27,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Image.asset(
                      width: double.infinity,
                      height: double.infinity,
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          
              SizedBox(height: 10,),

              // * DESCRIPCION O CAPTION
              Text(
                caption,
                style: textTheme.bodySmall?.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}