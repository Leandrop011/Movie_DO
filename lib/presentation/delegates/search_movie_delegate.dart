import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:movies_app/config/helpers/human_formats.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';


typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);


class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallBack searchMovie;
  List<Movie> initialMovies;
  //* USAMOS UN STREAM CONTROLLER PARA CONTROLAR CUANDO EL USUARIO YA DEJO DE ESCRIBIR Y AHI HACER LA PETCICION HTTP
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  //* Esto nos permite determinar un periodo de tiempo  
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.initialMovies, 
    required this.searchMovie
  }):super(
    textInputAction: TextInputAction.done
  );

  void clearStreams(){
    debounceMovies.close();
  }

  //* DEBOUNCE MANUAL(CONTROLAR QUE SE HAGA UNA PETICION HTTP, LUEGO DE QUE EL USUARIO HAYA ESCRITO LA PELICULA)
  void _onQueryChanged(String query){//* ESTA ES LA FUNC PARA EMITIR CAMBIOS
    isLoadingStream.add(true);//! cambiamos el valor del stream y asi trabaja

    if(_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer (
      Duration(milliseconds: 500), 
      () async{
        // if(query.isEmpty) {//* si el query es vacio
        //   debounceMovies.add([]);
          
        //   return;
        // }
        final movies = await searchMovie(query);//LAS MOVIES QUE NOS DA
        initialMovies = movies;
        debounceMovies.add(movies);
        isLoadingStream.add(false);
      },
    );
  }

  //* ES UN WIDGET QUE DEVUELVE LA MISMA DATA PERO ES UNO PARA CUANDO ESCRIBE Y 
  //* OTRO CUANDO PULSA EN BUSCAR, AMBOS SE APLICAN DE LA MISMA FORMA
  Widget buildResultsAndSuggestions(){
    return StreamBuilder(
      //* LAS PELICULAS INICIADAS AHORA LAS GUARDO EN EL DEBOUNCE ENTONCES SE CARGA CUANDO DOY EN BUSCAR
      initialData: initialMovies,
      stream: debounceMovies.stream, 
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              onMovieSelected: (context, movie){
                clearStreams();
                close(context, movie);
              }, 
              movie: movie
            );
          },
        );
      },
    );
  }
  
  @override
  String get searchFieldLabel => 'Buscar pelicula';

  //* ES COMO ESA PARTE DONDE DA VUELTAS LA CARGA DE ARCHIVOS
  //! EL VALOR DEL STREAM LO CONTROLAMOS EN EL DEBOUNCE 
  //! EL STREAM EMITE VALORES Y LE CONSULTA EL VALOR
  //! CUANDO EN UNA FUNCION(DEBOUNCE) CAMBIA LA DATA NOS DA OTRO VALOR
  //! Y EL STREAMBUILDER SE REDIBUJA
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      StreamBuilder(
        stream: isLoadingStream.stream,
        initialData: false,
        builder: (context, snapshot) {
          if(query.isEmpty){
            return SizedBox();
          }
          
          if(snapshot.data ?? false){
            return SpinPerfect(
              duration: Duration(seconds: 1),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: (){
                  query = '';
                }, 
                icon: Icon(Icons.refresh),
              ),
            );
          }

          return FadeIn(
              child: IconButton(
                onPressed: (){
                  query = '';//* establaecerle al texto que tiene(query) un string vacio 
                }, 
                icon: Icon(Icons.clear),
              ),
          );

        },
      ),
    ];
  }

  //* EL ICONO QUE NOS REGRESA A LA PANTALLA DE HOME <= 
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        //* Cerrar
        clearStreams();
        close(context, null);
      }, 
      icon: Icon(Icons.arrow_back_ios_new)
    );
  }

  //* LO QUE SALE CUANDO SE LE DA EN BUSCAR Y DA LAS MOVIES 
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  //* LO QUE APARECE AL INGRESAR TEXTO(MOVIES EN ESTA PARTE IMPLEMENTAMOS EL DEBOUNCE)
  @override
  Widget buildSuggestions(BuildContext context) {
   //* ESTA FUNCION SE MANDA A LLAMAR CADA QUE EL USUARIO PULSA O INGRESA ALGO
    _onQueryChanged(query);//! EL DEBOUNCER

    return buildResultsAndSuggestions();
  }
  
}



//* DISENO DE CADA PELICULA QUE MUESTRA
class _MovieItem extends ConsumerWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.onMovieSelected, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isDarck = ref.read(isdarckProvider);

    return FadeInRight(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          onMovieSelected(context, movie);
        },
        child: Padding(
          padding: EdgeInsets.symmetric( horizontal: 10, vertical: 10,),
        
          child: SizedBox(
            height: size.height * 0.23,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDarck ? 
                const Color.fromARGB(255, 68, 66, 66)
                :
                const Color.fromARGB(255, 251, 251, 251),
                  
                boxShadow: [
                  
                  BoxShadow(
                    color: const Color.fromARGB(255, 111, 107, 107),
                    blurRadius: 5,
                    offset: Offset(2, 4)
                  )
                ]
              ),
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //* Image
                  SizedBox(
                    width: size.width * 0.3,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: Image.network(
                        movie.posterPath,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if(loadingProgress != null){
                            return Center(
                              child: LoadingAnimationWidget.hexagonDots(
                                color: const Color.fromARGB(255, 187, 185, 185), 
                                size: 40
                              )
                            );
                          }
                          return FadeIn(child: child);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
              
                  //* Descripcion
                  SizedBox(
                    width: size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(movie.title, style: textStyle.titleMedium,),
                        SizedBox(height: 5,),
                        
                        (movie.overview != '') ?
                        Text(movie.overview, maxLines: 3, overflow: TextOverflow.ellipsis,)
                        :
                        Text('No Description'),
              
                        SizedBox(height: 5,),
              
                        Row(
                          children: [
                            Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                            SizedBox(width: 5,),
                            Text(
                              HumanFormats.humanReadableNumber(movie.voteAverage, 1),
                              style: textStyle.bodyMedium!.copyWith(color: Colors.yellow.shade800),
                            )
                      
                          ],
                        )
              
              
                      ],
                    ),
                  )
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}