import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';
//todo, usaremos un SWIPER, para el carrucel => card_swiper
class MoviesSlideshow extends StatelessWidget {

  final List<Movie> movies; 

  const MoviesSlideshow({
    super.key, 
    required this.movies
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(//todo,  porque quiero un ancho para cada elemento
          height: size.height * 0.35,//? AQUI ES DONDE SE LE DA TAMANO DE ALTO
          width: double.infinity,
          child: Swiper(
            viewportFraction: 0.81,//todo, para ver como el pre visualizer del slide anteriori y el sigueinte
            scale: 0.85,//todo, es para que en el actual sea mas grande y los de adelante y atras sean mas pequenos
            autoplay: true,//todo, es para que se mueva solo 
            pagination: SwiperPagination(//todo, para que coloque esos puntitos de cuantas movies hay
              margin: EdgeInsetsGeometry.only(top: 0),
              builder: DotSwiperPaginationBuilder(
                activeColor: colors.primary,
                color: colors.secondary,
        
              )
            ),
            
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              
              return GestureDetector(
                onTap: () {
                  context.push('/home/0/movie/${movie.id}');
                },
                child: _Slide(movie: movie)
              );//todo, construye todas, cuando avanza y se consulta el index
            },
          ),
        
        ),

      ],
    );
  }
}

//todo, diseno de cada elemento del carrucel
class _Slide extends ConsumerWidget {

  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    //* Hasta que cargue
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [//todo, para como sobreado
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 8)
        )
      ],
    );
    final isDarck = ref.watch(isdarckProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: 30,
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
      
          //* FOTO DE LA PELICULA
          DecoratedBox(
            decoration: decoration,
            
            child: Container(
              // * lo que faltaba es esto para que ocupe todo
              // * porque no le habia definido las dimensiones a usar
              // ! Siempre colocar simensiones por buena practica
              // * porque el fixt boxfitCover no funciona aqui
              // * PARA QUE LA IMAGEN OCUPE TODO1 EL ESPACIO DE LA CAJA
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1, 
                  color: isDarck ? 
                  Colors.white38
                  :
                  Colors.black26
                ),
                borderRadius: BorderRadius.circular(17)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  movie.backdropPath,//todo, consultamos a esa cierta pelicula, segune el index
                  fit: BoxFit.cover,
                  // height: double.infinity,
                  //todo, esto es como para que mientras carga se coloque algo
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black12
                        )
                      );
                    }
              
                    //todo, para hacerla la animacion de cuadno la imagen entre, entre con suavidad
                    return FadeIn(child: child);
                  },
                )
              ),
            ),
              
          ),
      
          //* GRADIENTE
          SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,//* inicio
                    end: Alignment.bottomCenter,//* final
                    stops: [0.7, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black87
                    ]
                  )
                )
              ),
          ),
      
          //* TITULO DE LA PELICULA
          Padding(
            padding: EdgeInsetsGeometry.only(left: 10, bottom: 10),
            child: Text(
              movie.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16
              )
            ),
      
          )
      
        ],
      ),
    );
  }
}