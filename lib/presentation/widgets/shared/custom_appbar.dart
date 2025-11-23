import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/presentation/delegates/search_movie_delegate.dart';
import 'package:movies_app/presentation/providers/config/isdarck_provider.dart';
import 'package:movies_app/presentation/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isdarck = ref.watch(isdarckProvider);
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SafeArea(//todo para que ocupe todo menos esa parte del notch
      child: SizedBox( 
        width: double.infinity,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: 15),
              child: Icon(Icons.movie_creation_outlined, color: colors.primary,)
            ),
            SizedBox(width: 5,),
            Text('MovieDo', style: titleStyle,),
            
      
            Spacer(),//todo, que tome todo el espacio disponibleentre esos widgets
            //todo, por ende lo mueve hasta el final
            
            IconButton(

              onPressed: () {
                final searchedMovies = ref.read(searchedMoviesProvider);
                final searchQuery = ref.read(searchQueryProvider);
                

                showSearch<Movie?>(//* esto nos puede devolver una pelicula
                  query: searchQuery,
                  context: context, 
                  delegate: SearchMovieDelegate(
                    initialMovies: searchedMovies,
                    searchMovie: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery,
                  )
                ).then((movie) {//* SI EL USUARIO SELECCIONA ESO CAPTURA EL VALOR
                  if(movie == null) return;
                  //! CAMBIAMOS LA DIRECCION DEL ROUTER ENTONCES AQUI CAMBIAMOS
                  context.push('/home/0/movie/${movie.id}');
                  
                });
              }, 
              icon: Icon(Icons.search)
            ),
            
            IconButton(
              onPressed: (){
                ref.read(isdarckProvider.notifier).update((value) => !value);
              }, 
              icon: isdarck? 
                    Icon(Icons.light_mode_outlined)
                    :
                    Icon(Icons.dark_mode)
            )
          ],
        ),
      ),

    );
  }
}