// * WIDGET DEL RATING
import 'package:flutter/material.dart';
import 'package:movies_app/features/movies/domain/domain.dart';

class CustomViewRating extends StatelessWidget {
  const CustomViewRating({
    super.key, 
    required this.size,
    required this.movie,
    required this.textStyle,
  });

  final Size size;
  final Movie movie;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: size.width * 0.01,
      top: size.height * 0.008,
      child: Container(
        width: size.width * 0.18,
        height: size.height * 0.045,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
            const SizedBox(width: 3,),
            Text(
              movie.voteAverage.toStringAsFixed(1), 
              style: textStyle.bodyMedium?.copyWith(color: Colors.yellow.shade800),
            ),
          ],
        ),
      ),
    );
  }
}

