import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return SafeArea(//todo para que ocupe todo menos esa parte del notch
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
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
                onPressed: (){}, 
                icon: Icon(Icons.search)
              )
            ],
          ),
        ),
        
      ),

    );
  }
}