
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/config/helpers/human_formats.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';

//TODO, ENTENDER ESTO
typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallBack searchMovie;

  SearchMovieDelegate({ required this.searchMovie});

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  //* ES COMO ESA PARTE DONDE DA VUELTAS LA CARGA DE ARCHIVOS
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      if(query.isNotEmpty)
          FadeIn(
            child: IconButton(
              onPressed: (){
                query = '';//* establaecerle al texto que tiene(query) un string vacio 
              }, 
              icon: Icon(Icons.clear)
            ),
          )
    ];
  }

  //* EL ICONO QUE NOS REGRESA A LA PANTALLA DE HOME <= 
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        //* Cerrar
        close(context, null);
      }, 
      icon: Icon(Icons.arrow_back_ios_new)
    );
  }

  //* LO QUE SALE CUANDO NO HAY RESULTADOS
  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('NO ENCONTRADO....'));
  }

  //* LO QUE APARECE AL INGRESAR TEXTO
  @override
  Widget buildSuggestions(BuildContext context) {

    return FutureBuilder(
      future: searchMovie(query), 
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            return _MovieItem(
              movie: movie,
              onMovieSelected: close,
            );
          },
        );

      },
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
    final isDarck = ref.read(isdarckProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 10, vertical: 10),
      
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
                      if(loadingProgress != null) return Center(child: CircularProgressIndicator(strokeWidth: 2, ));
                  
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
                  children: [
                    Text(movie.title, style: textStyle.titleMedium,),
                    SizedBox(height: 5,),
                    
                    (movie.overview != '') ?
                    Text(movie.overview, maxLines: 5, overflow: TextOverflow.ellipsis,)
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
    );
  }
}