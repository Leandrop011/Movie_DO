import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageMovieView extends StatelessWidget {

  final String image;
  final IconData iconErrorWidget;
  final Size size;
  final double? valueSize;

  const CustomImageMovieView({
    super.key, 
    required this.image, 
    required this.iconErrorWidget, 
    required this.size, 
    this.valueSize = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: image,
        height: size.height * valueSize!,
        width: size.width * valueSize!,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Image.asset( 
            width: double.infinity,
            height: double.infinity,
            'assets/loaders/movie_do-loader.gif', 
            fit: BoxFit.cover, 
          );
        },
    
        errorWidget: (context, url, error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Error, fallo en carga'),
                const SizedBox(height: 10,),
                Icon(Icons.movie, size: size.height * 0.1,)
              ],
            ),
          );
        },
      );
  }
}