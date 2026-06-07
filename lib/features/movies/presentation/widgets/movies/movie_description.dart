
//* ELEMENTOS QUE ESTARAN DENTRO DE LA CAJA DE PELICULA(like overview), TITLE, DETAILS
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../features.dart';

class ElementsInDetails extends ConsumerStatefulWidget {
  const ElementsInDetails({
    super.key, 
    required this.fount,
    required this.size,
    required this.movie,
    required this.textStyle,
  });

  final bool fount;
  final Size size;
  final Movie movie;
  final TextTheme textStyle;

  @override
  ConsumerState<ElementsInDetails> createState() => _ElementsInDetailsState();
}

class _ElementsInDetailsState extends ConsumerState<ElementsInDetails> {

  var enabledValue = false;

  @override
  void initState() {
    super.initState();

    enabledValue = ref.read(valueInformationMovieProvider(widget.movie.overview.length)).enabled;
  }

  @override
  Widget build(BuildContext context) {
    
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final informationMovieLength = widget.movie.overview.length;
    final linesState = ref.watch(valueInformationMovieProvider(informationMovieLength)).linesInformation;
    final activeStatus = ref.watch(valueInformationMovieProvider(informationMovieLength)).active;

    return Padding(
      padding: const EdgeInsetsGeometry.only(top: 15, right: 5, left: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: CustomImageMovieView(
              image: widget.movie.posterPath, 
              iconErrorWidget: Icons.movie, 
              size: widget.size,
              valueSize: 0.23,
            ),
          ),
          
          const SizedBox(width: 10,),
      
          SizedBox( 
            width: widget.size.width * 0.67,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.movie.title, 
                    style: textStyle.titleLarge,
                  ),
                ),
                
                const SizedBox(height: 8,),
            
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.movie.overview, 
                    style: textStyle.titleSmall,
                    maxLines: linesState, // * A PROVIDER PROVIDES THIS
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                ),
    
                SizedBox(height: widget.size.height * 0.01,),
    
               
                (enabledValue == true) ? 
                SizedBox(
                  width: widget.size.width * 0.3,
                  height: widget.size.height * 0.05,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
    
                      ref.read(valueInformationMovieProvider(informationMovieLength).notifier).changeValueInformation(!activeStatus, );
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(5),
                        
                      ),
                      child: Center(
                        child: Text(
                          (activeStatus) ? 'Leer menos' : 'Leer mas....', 
                          style: textStyle.bodySmall?.copyWith( color: Colors.black, fontSize: widget.size.width * 0.035),
                          
                        ),
                      ),
                    ),
                  )
                ):
                const SizedBox(),
    
                SizedBox(height: widget.size.height * 0.01,),
    
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade900,),
                      const SizedBox(width: 5,),
                      Text(widget.movie.voteAverage.toStringAsFixed(2), style: TextStyle(color: Colors.yellow.shade900),),
                      
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Estreno: ', 
                        style: textStyle.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold, 
                          fontSize: 15, 
                          color: widget.fount ? Colors.grey : Colors.grey.shade700 
                          ),
                      ),
                      Text(
                        DateFormat('yyyy/MM/dd').format(widget.movie.releaseDate), 
                        style: textStyle.bodySmall?.copyWith(
                          fontSize: 14, 
                          color: widget.fount ? Colors.grey : Colors.grey.shade700 
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}