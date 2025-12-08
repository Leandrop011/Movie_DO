import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/config/helpers/human_formats.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';


class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final bool? widthN;
  final bool? heightN;

  final VoidCallback? loadNextPage;//* para hacer scroll infinito

  const MovieHorizontalListview({
    super.key, 
    required this.movies, 
    this.title, 
    this.subTitle, 
    this.loadNextPage, 
    this.widthN, 
    this.heightN = false
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
        
        //todo, para saber si esta caso por llegar al final hacer algo
        if( scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent){
          widget.loadNextPage!();
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();//todo, buena practica 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(//todo, para que no se desborde
      height: widget.heightN! ? 
      450
      :
      390,
      child: Column(
        children: [

          //todo, el 'encabezado'
          if(widget.title != null || widget.subTitle != null)//todo, solo renderiza si es diferente de null lo renderiza
          _Tittle(title: widget.title, subTittle: widget.subTitle,),

          //todo, el listado de peliculas

          Expanded(//todo, porque necesito un tamano especifico para ellistView
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final movie = widget.movies[index];

                return FadeInRight(child: _Slide(movie: movie, heightN: widget.heightN ?? false, widthN: widget.widthN ?? false,));
              },
            )
          )


        ],
      ),
    );
  }
}

//todo, encabezado que dice en cines y fecha
class _Tittle extends StatelessWidget {
  final String? title;
  final String? subTittle;

  const _Tittle({
    this.title, 
    this.subTittle
  });

  @override
  Widget build(BuildContext context) {
    final tittleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: EdgeInsets.only(top: 10, right: 5, left: 5),
      margin: EdgeInsets.symmetric(horizontal: 10,),
      child: Row(
        children: [

          if(title != null)//todo, una condicion para segurarse que no sea null
            Text(title!, style: tittleStyle,),
          
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

//todo, la cajita de las peliculas //* diseno
class _Slide extends ConsumerWidget {
  final Movie movie;
  final bool widthN;
  final bool heightN;

  const _Slide({
    required this.movie, 
    required this.widthN, 
    required this.heightN
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textStyle = Theme.of(context).textTheme;
    final isdarck = ref.read(isdarckProvider);
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),//todo, un marge de modo horizontal
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        //context.push('/movie/${movie.id}'); //! Esta ruta ya no existe porque se cambio el router
        //! Antes solo era /movie/${movie.id} porque la direccion raiz era /, ahora es home
        onTap: () => context.push('/home/0/movie/${movie.id}'),//* Por ser el hijo se une el home 0( la pagina 1), con el hijo movie id
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Imagen
            SizedBox(
              // width: widthN ? //! ESTO ES PARA CONTROLAR EL TAMANO Y NO SE DESBORDE
              // 300
              // :
              // 150,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(
                  heightN ?
                  5
                  :
                  20
                ),
                child: Image.network(
                  movie.posterPath,
                  width: widthN ?
                  200
                  :
                  150
                  ,
                  height: heightN ?
                  310
                  :
                  250
                  ,
                  fit: BoxFit.cover,
                
                  //todo, un loading
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {//todo, cuando ya es null mostrara la imagen, de lo contrario tiene algo en su sistema 
                      return Padding(
                        padding: EdgeInsetsGeometry.only(top: size.height * 0.1, bottom: size.height * 0.1),
                        child: Center(child: LoadingAnimationWidget.hexagonDots(
                          color: isdarck ?
                          const Color.fromARGB(255, 194, 192, 192)
                          :
                          const Color.fromARGB(255, 60, 60, 60),
                          size: 45
                        ),),
                      );
                    }
                
                    return FadeIn(child: child);
                  },
                ),
              ),
            ),  
        
            SizedBox(height: 5,),
        
            //* Titulo
        
            SizedBox(
              width: 150,
              child: Text(
                movie.title,
                maxLines: 2,
                style: textStyle.titleSmall,
              ),
            ),
        
            //* Rating
        
            SizedBox(//todo, para que tenga un limite 
              width: 150,
              child: Row(
              
                children: [
                  Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
                  SizedBox(width: 3,),
                  Text('${movie.voteAverage}', style: textStyle.bodyMedium?.copyWith(color: Colors.yellow.shade800),),
                  const Spacer(),
                  //todo, solucionar problema de no transformacion correcta del numero
                  Text(HumanFormats.humanReadableNumber(movie.popularity), style: textStyle.bodySmall,),
                  
                ],
              ),
            )
            
          ],
        ),
      ),
    );
  }
}
