import 'dart:ui';

import 'package:flutter/material.dart';

//! APPBAR CON SLIVERAPPBAR CON FONDO TRANSPARENTE
class GlassSliverAppBar extends StatelessWidget {
  final double expandedHeight;
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final double blurIntensity;
  final Color glassColor;
  final double glassOpacity;

  const GlassSliverAppBar({super.key, 
    required this.expandedHeight,
    required this.title,
    this.leading,
    this.actions,
    this.blurIntensity = 10.0,
    this.glassColor = Colors.white,
    this.glassOpacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    
    return SliverAppBar(
      
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      actions: actions,
      leading: leading,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        // borderRadius: BorderRadiusGeometry.only(
        //   bottomLeft: Radius.circular(20),
        // ),
        child: BackdropFilter( 
          filter: ImageFilter.blur(
            sigmaX: blurIntensity, 
            sigmaY: blurIntensity
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  glassColor.withOpacity(glassOpacity),
                  glassColor.withOpacity(glassOpacity * 0.5),
                ],
              ),
              border: const Border(
                bottom: BorderSide(
                  //color: Colors.white.withOpacity(0.2),
                  width: 1
                ),
              ),
            ),
            child: FlexibleSpaceBar(
              title: Text(
                title,
              
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
           ),
        ),
      ),
    );
  }
}