import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/movie.dart';
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
    return Column(
      children: [
        SizedBox(//todo,  porque quiero un ancho para cada elemento
          height: 250,
          width: double.infinity,
          child: Swiper(
            viewportFraction: 0.8,//todo, para ver como el pre visualizer del slide anteriori y el sigueinte
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
                  context.push('/movie/${movie.id}');
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
class _Slide extends StatelessWidget {

  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: [//todo, para como sobreado
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 8)
        )
      ]
    );

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
              
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                movie.backdropPath,//todo, consultamos a esa cierta pelicula, segune el index
                fit: BoxFit.cover,
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

          //* GRADIENTE
          SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
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
            padding: EdgeInsetsGeometry.only(left: 17, bottom: 10),
            child: Text(
              movie.title, 
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 17
              )
            ),

          )

        ],
      ),
    );
  }
}