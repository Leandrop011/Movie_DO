import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/config/config.dart';

import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/providers.dart';
import 'package:movies_app/features/movies/presentation/widgets/shared/shared.dart';


class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  // final bool? widthN;
  // final bool? heightN;

  final VoidCallback? loadNextPage;//* para hacer scroll infinito

  const MovieHorizontalListview({
    super.key, 
    required this.movies, 
    this.title, 
    this.loadNextPage, 
    // this.widthN, 
    // this.heightN = false
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        if (widget.loadNextPage == null) return;
        
        //? para saber si esta caso por llegar al final hacer algo
        if( scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent){
          widget.loadNextPage!();
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();//? buena practica 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(//? para que no se desborde
      //! AQUI ES DONDE DEFINO EL TAMANO MAXIMO DE LOS ELEMENTOS DE ESE SCROLL HORIZONTAL
      //! SI LE DOY MAS, PUES PUEDO AUMENTAR SU TAMANO, DISENO RESPONSIVO
      //! OJO HAY QUE PRIORIZAR QUE FUNCIONE EN OTROS DISPOSITIVOS QUE AL DISENO
      height: size.height * 0.55,
      // widget.heightN! ? 
      // size.height * 0.57
      // :
      // size.height * 0.49,
      child: Column(
        children: [
          

          // ? el 'encabezado'
          if(widget.title != null)// ? solo renderiza si es diferente de null lo renderiza
          _Tittle(title: widget.title),

          // ? el listado de peliculas

          Expanded(// ? porque necesito un tamano especifico para ellistView
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final movie = widget.movies[index];

                //! AQUI CREA A CADA ELEMENTO
                return FadeInRight(
                  from: random.nextInt(100) + 80,
                  child: _Slide(movie: movie,)
                );
              },
            )
          ),

        ],
      ),
    );
  }
}

// * Encabezado que dice en cines y fecha
class _Tittle extends StatelessWidget {
  final String? title;

  const _Tittle({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10,),
      child: Row(
        children: [

          const SizedBox(width: 5,),

          CustomWidgetForSections(size: size, colors: colors),
          
          if(title != null)// ? Una condicion para segurarse que no sea null
            Text(title!, style: textTheme.bodyMedium?.copyWith(fontSize: size.width * 0.055,),),
          
          const Spacer(),

          SizedBox(
            width: size.width * 0.35,
            height: size.height * 0.05,
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                // minimumSize: Size.zero,
                // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                )
              ),
              onPressed: (){
            
                HapticFeedback.heavyImpact();
            
                context.push('/show_more_movies/$title');
              }, 
              child: Row(
                children: [
                  Text('Ver Mas', style: textTheme.bodyMedium,),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_sharp)
                ],
              )
            ),
          )

        ],
      ),
    );
  }
}

// * La cajita de las peliculas //* diseno
class _Slide extends ConsumerWidget {
  final Movie movie;

  const _Slide({
    required this.movie, 
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textStyle = Theme.of(context).textTheme;

    final fount = ref.read(isdarckProvider).fount;
    final size = MediaQuery.of(context).size;



    return SizedBox(//! PARA DISENO RESPONSIVO Y QUE MAXIMO OCUPE ESE ESPACIO
      width: size.width * 0.42,
      height: size.height * 0.5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),// ? un marge de modo horizontal
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          //context.push('/movie/${movie.id}'); //! Esta ruta ya no existe porque se cambio el router
          //! Antes solo era /movie/${movie.id} porque la direccion raiz era /, ahora es home
          onTap: () {
            // ? PARA QUE EL TELEFONO DE UNA PEQUENA VIBRACION CADA QUE SE HACE EL ONTAP
            // HapticFeedback.lightImpact();

            context.push('/home/0/movie/${movie.id}');
          },//* Por ser el hijo se une el home 0( la pagina 1), con el hijo movie id
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  //* Imagen
                  _ViewImage(size: size, movie: movie),

                  // * RATING
                  CustomViewRating(size: size, movie: movie, textStyle: textStyle),

                ],
              ),    
          
              SizedBox(height: size.height * 0.008,),
              // Spacer(),
          
              //* Titulo
          
              Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textStyle.titleSmall?.copyWith(color: fount ?Colors.grey : Colors.black, fontSize: size.width * 0.04),
              ),
          
            

              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    Text(
                      HumanFormats.number(movie.popularity.toDouble()), 
                      style: textStyle.bodySmall?.copyWith(color: fount ?Colors.grey : Colors.black),
                    ),
                    SizedBox(width: size.width * 0.008,),
                    Icon(Icons.visibility, size: size.width * 0.05, color: fount ?Colors.grey : Colors.black,),
                    // const Spacer(),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

// * WIDGET DE LA IMAGEN
class _ViewImage extends StatelessWidget {
  const _ViewImage({
    required this.size,
    required this.movie,
  });

  final Size size;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,//* LO MAXIMO QUE PUEDA OCUPAR
      height: size.height * 0.33,
    
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(5),
        child: CustomImageMovieView(
          image: movie.posterPath, 
          iconErrorWidget: Icons.movie, 
          size: size,
          valueSize: 0.3,
        ),
      ),
    );
  }
}

