import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/domain/entities/movie.dart';


class MovieTop extends StatelessWidget {
  
  final Movie movie;

  const MovieTop({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        context.push('/movie/${movie.id}');
      },
      child: Padding(
        padding: const EdgeInsets.only(
          //top: 3, 
          right: 10,
          left: 10, 
          bottom: 10,
        ),
        child: SizedBox(
          width: size.width * 0.85,
          height: size.height * 0.6,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.only(bottom: 25, left: 10, right: 10),
                
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.push('/movie/${movie.id}');
                  },
                  child: _CustomButton()
                ),
                
              ),

              SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,//* inicio
                      end: Alignment.bottomCenter,//* final
                      stops: [0.92, 1.2],
                      colors: [
                        Colors.transparent,
                        Colors.black87
                      ]
                    )
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.75,
      height: size.height * 0.06,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 0.3,
            color: Colors.white
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.white,),
            SizedBox(width: 10,),
            Text('Ver Detalles', style: TextStyle(color: Colors.white),),
          ],
        ),
      )
    );
  }
}