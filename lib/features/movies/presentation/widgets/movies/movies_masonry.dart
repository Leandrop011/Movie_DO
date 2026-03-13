import 'package:flutter/material.dart';
import 'package:movies_app/features/movies/domain/entities/entities.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movies_app/features/movies/presentation/widgets/movies/movies.dart';

class MoviesMasonry extends StatefulWidget {

  final List<Movie> movies;
  // * funcion future que devuleve una list de movies
  final Future<List<Movie>> Function()? loadNextPage;

  const MoviesMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MoviesMasonry> createState() => _MoviesMasonryState();
}

class _MoviesMasonryState extends State<MoviesMasonry> {

  bool isLastPage = false;
  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    scrollController.addListener((){
      if(scrollController.position.pixels + 100 >= scrollController.position.maxScrollExtent){
        loadNextPageMovies();
      }
    });
  }

  @override
  void dispose() {//!SIEMPRE PONER CUANDO ALGO TIENE QUE ESTAR ESCUCHANDOSE CON LISTENER
    scrollController.dispose();
    super.dispose();
  }

  void loadNextPageMovies() async{
    if(isLoading || isLastPage)return;
    if(widget.loadNextPage == null)return;

    isLoading = true;
      
  
    final movies = await widget.loadNextPage!();
    
    
    isLoading = false;

    if(movies.isEmpty){
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: MasonryGridView.count(
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        crossAxisCount: 3, //* Numero de Columnas
        mainAxisSpacing: 10,//* separacion en y
        crossAxisSpacing: 10,//* separacion en x
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          
          // ?SI EL INDEX ES PAR
          if(index %2 == 0){//! SEGUN EL INDEX(SI ES PAR EJECUTA LA LOGICA)
            return MoviePosterLink(movie: widget.movies[index], index: false,);
          }

          //? SI EL INDEX ES IMPAR
          return MoviePosterLink(movie: widget.movies[index], index: true,);
        },
      ),
    );
  }
}

