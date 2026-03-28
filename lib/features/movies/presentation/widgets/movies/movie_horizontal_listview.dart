import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/config/config.dart';

import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:movies_app/features/movies/presentation/providers/movies/movies.dart';


class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  // final bool? widthN;
  // final bool? heightN;

  final VoidCallback? loadNextPage;//* para hacer scroll infinito

  const MovieHorizontalListview({
    super.key, 
    required this.movies, 
    this.title, 
    this.subTitle, 
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
          if(widget.title != null || widget.subTitle != null)// ? solo renderiza si es diferente de null lo renderiza
          _Tittle(title: widget.title, subTittle: widget.subTitle,),

          // ? el listado de peliculas

          Expanded(// ? porque necesito un tamano especifico para ellistView
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
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
  final String? subTittle;

  const _Tittle({
    this.title, 
    this.subTittle
  });

  @override
  Widget build(BuildContext context) {
    final tittleStyle = Theme.of(context).textTheme.bodySmall;
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10,),
      child: Row(
        children: [

          Icon(Icons.label),

          SizedBox(width: 5,),

          if(title != null)//todo, una condicion para segurarse que no sea null
            Text(title!, style: tittleStyle?.copyWith(fontSize: size.width * 0.055,),),
          
          Spacer(),

          if(subTittle != null)
            FilledButton.tonal(
              style: ButtonStyle(//todo, tamano del boton
                visualDensity: VisualDensity.compact
              ),
              onPressed: (){}, 
              child: Text(subTittle!,)//todo, es '!' es para forzarlo, es como decirle eso nunca va a ser null
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

    // final isdarck = ref.read(isdarckProvider);
    final size = MediaQuery.of(context).size;



    return SizedBox(//! PARA DISENO RESPONSIVO Y QUE MAXIMO OCUPE ESE ESPACIO
      width: size.width * 0.4,
      // height: size.height * 0.5,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),//todo, un marge de modo horizontal
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
              //* Imagen
              SizedBox(
                width: double.infinity,//* LO MAXIMO QUE PUEDA OCUPAR
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: FadeInImage(
                    height: size.height * 0.31,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/loaders/movie_do-loader.gif'), 
                    
                    image: NetworkImage(
                      movie.posterPath,
                    ),
                  )
                ),
              ),  
          
              SizedBox(height: size.height * 0.008,),
              // Spacer(),
          
              //* Titulo
          
              SizedBox(
                // width: 150,
                // height: size.height * 0.03,
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.titleSmall,
                ),
              ),
          
              //* Rating
      
              SizedBox(//? para que tenga un limite 
                width: size.width * 0.35,
                // height: size.height * 0.03,
                child: Row(
                
                  children: [
                    Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
                    const SizedBox(width: 3,),
                    Text(movie.voteAverage.toStringAsFixed(2), style: textStyle.bodyMedium?.copyWith(color: Colors.yellow.shade800),),
                    const Spacer(),
  
                    Text(HumanFormats.number(movie.popularity.toDouble()), style: textStyle.bodySmall,),
                    SizedBox(width: size.width * 0.008,),
                    Icon(Icons.visibility, size: size.width * 0.05,),
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

