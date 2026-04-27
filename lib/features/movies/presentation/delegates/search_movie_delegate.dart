import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:movies_app/features/movies/domain/entities/entities.dart';



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

  // void clearStreams(){
  //   debounceMovies.close();
  // }
  //todo, estudiar esto
  void cleanup(){
    _debounceTimer?.cancel();
  }

  //* DEBOUNCE MANUAL(CONTROLAR QUE SE HAGA UNA PETICION HTTP, LUEGO DE QUE EL USUARIO HAYA ESCRITO LA PELICULA)
  void _onQueryChanged(String query){
    if (isLoadingStream.isClosed) return;
    isLoadingStream.add(true);//! cambiamos el valor del stream y asi trabaja

    if(_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer (
      const Duration(milliseconds: 500), 
      () async{
        final movies = await searchMovie(query);//LAS MOVIES QUE NOS DA
        initialMovies = movies;

        if (!debounceMovies.isClosed) {
          debounceMovies.add(movies);
        }
        if (!isLoadingStream.isClosed) {
          isLoadingStream.add(false);
        }
      },
    );
  }

  Widget buildResultsAndSuggestions(){


    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream, 
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        final size = MediaQuery.of(context).size;
        final textTheme = Theme.of(context).textTheme;

        return (movies.isEmpty) ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_filter_rounded, size: size.width * 0.3,),
              const SizedBox(height: 10,),
              Text(
                'Ingresa lo que deseas ver...', 
                style: textTheme.bodySmall?.copyWith(fontSize: size.width * 0.04)
              ),
            ],
          ),
        )
        :
        ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              onMovieSelected: (context, movie){
                cleanup();
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
            return const SizedBox();
          }
          
          if(snapshot.data ?? false){
            return SpinPerfect(
              duration: const Duration(seconds: 1),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: (){
                  //query = '';
                }, 
                icon: const Icon(Icons.refresh),
              ),
            );
          }

          return FadeIn(
              child: IconButton(
                onPressed: (){
                  HapticFeedback.lightImpact();
                  query = '';//* establaecerle al texto que tiene(query) un string vacio 
                }, 
                icon: const Icon(Icons.clear),
              ),
          );

        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        //* Cerrar
        cleanup();
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back_ios_new)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   //* ESTA FUNCION SE MANDA A LLAMAR CADA QUE EL USUARIO PULSA O INGRESA ALGO
    _onQueryChanged(query);//! FUNCION DEBOUNCER

    return GestureDetector(
      onTapDown: (_) => FocusScope.of(context).unfocus(),
      child: buildResultsAndSuggestions()
    );
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
    // final isDarck = ref.read(isdarckProvider).fount;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onMovieSelected(context, movie);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10,),
        
          child: SizedBox(
            //* MAXIMOS
            // height: size.height * 0.2,
            width: size.width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //* Image
                SizedBox(
                  width: size.width * 0.265,
                  height: size.height * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(5),
                    child: FadeInImage(
                      
                      width: double.infinity,
                      height: double.infinity,
            
                      placeholder: const AssetImage('assets/loaders/movie_do-loader.gif'), 
            
                      fit: BoxFit.cover,
            
                      image: NetworkImage(
                      movie.posterPath,
                    ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                //* Descripcion
                SizedBox(
                  //! AQUI ES EL TAMANO MAXIMO DE EL OVERVIEW(LO REDUCIMOS TENEMOS MAS ESPACIO)
                  width: size.width * 0.55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(movie.title, style: textStyle.titleMedium, maxLines: 2,),
                      const SizedBox(height: 5,),
                      
                      (movie.overview != '') ?
                      Text(movie.overview, maxLines: 4, overflow: TextOverflow.ellipsis, style: textStyle.titleSmall,)
                      :
                      const Text('No Description'),
            
                      const SizedBox(height: 5,),
            
                      Row(
                        children: [
                          Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                          const SizedBox(width: 5,),
                          Text(
                            NumberFormat('###.##').format(movie.voteAverage),
                            style: textStyle.bodyMedium!.copyWith(color: Colors.yellow.shade800),
                          ),
                    
                        ],
                      ),
            
            
                    ],
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

