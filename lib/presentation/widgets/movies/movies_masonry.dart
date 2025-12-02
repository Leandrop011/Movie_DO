import 'package:flutter/material.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movies_app/presentation/widgets/movies/movie_poster_link.dart';

class MoviesMasonry extends StatefulWidget {

  final List<Movie> movies;
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
      if(scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent){
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

    setState(() {
      isLoading = true;
      
    });
    final movies = await widget.loadNextPage!();
    
    
    isLoading = false;

    if(movies.isEmpty){
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10 ),
      child: MasonryGridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        crossAxisCount: 3, //* Numero de Columnas
        mainAxisSpacing: 10,//* separacion en x
        crossAxisSpacing: 10,//* separacion en y
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          if(index == 1){//! SEGUN EL INDEX(ELEMENTO POR ELEMENTO Y SE RECORRE POR FILA), SI ESTA EN EL INDEX 1, HACEMOS LO QUE DICE
            return Column(
              children: [
                SizedBox(height: 50,),
                MoviePosterLink(movie: widget.movies[index])
              ],
            );
          }

      
          return MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}