// * Encabezado que dice en cines y fecha
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../features.dart';

class Tittle extends StatelessWidget {
  final String? title;

  const Tittle({
    super.key, 
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Row(
        children: [

          const SizedBox(width: 5,),

          CustomWidgetForSections(size: size, colors: colors),
          
          if(title != null)// ? Una condicion para segurarse que no sea null
            Text(title!, style: textTheme.bodyMedium?.copyWith(fontSize: size.width * 0.055,),),
          
          const Spacer(),

          SizedBox(
            width: size.width * 0.35,
            height: size.height * 0.05,
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                // minimumSize: Size.zero,
                // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                )
              ),
              onPressed: (){
            
                HapticFeedback.heavyImpact();
            
                context.push('/show_more_movies/$title');
              }, 
              child: Row(
                children: [
                  Text('Ver Mas', style: textTheme.bodyMedium,),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_sharp)
                ],
              )
            ),
          )

        ],
      ),
    );
  }
}