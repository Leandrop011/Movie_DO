import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSettingsCards extends StatelessWidget {

  final String type;
  final IconData icon;
  final String link;

  const CustomSettingsCards({
    super.key, 
    required this.type, 
    required this.icon, 
    required this.link
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        right: size.width * 0.04, 
        left: size.width * 0.04, 
        bottom: size.height * 0.02
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5, 
            color: Colors.white70
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            context.push('/$link');//* RUTA QUE SE BRINDA
          },
          child: ListTile(
            title: Text(type),
            leading: Icon(icon, color: colors.primary,),
            trailing: Icon(Icons.arrow_forward_ios, color: colors.primary,),
          ),
        ),
      ),
    );
  }
}