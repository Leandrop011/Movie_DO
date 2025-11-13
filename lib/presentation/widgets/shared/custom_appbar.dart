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
            Icon(Icons.movie_creation_outlined, color: colors.primary,),
            SizedBox(width: 5,),
            Text('MovieDo', style: titleStyle,),
            
      
            Spacer(),//todo, que tome todo el espacio disponibleentre esos widgets
            //todo, por ende lo mueve hasta el final
            
            IconButton(

              onPressed: () {
                final movieRepository = ref.read(movieRepositoryProvider);

                showSearch<Movie?>(//* esto nos puede devolver una pelicula
                  context: context, 
                  delegate: SearchMovieDelegate(
                    searchMovie: movieRepository.searchMovies //* solo la referencia
                  )
                ).then((movie) {//* puede volver algo
                  if(movie == null) return;
                  
                  context.push('/movie/${movie.id}');
                  
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