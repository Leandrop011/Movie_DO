import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';


class CustomAppbarTransparent extends StatelessWidget implements PreferredSizeWidget {

  final String tittle;
  final IconData leadingIcon;
  final List<Widget> actions;
  // final VoidCallback? onIconPressed;
  final double blurIntensity;
  final double glassOpacity;
  final bool? leadingButton;

  const CustomAppbarTransparent( {
    super.key, 
    required this.leadingIcon, 
    required this.actions,
    this.blurIntensity = 10, 
    this.glassOpacity = 0.1, 
    required this.tittle, 
    this.leadingButton = false, 
    // required this.onIconPressed
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          tittle,
          style: TextStyle(
            color: colors.primary,
            fontWeight: FontWeight.w400,
            fontSize: 23
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0,),
        child: leadingButton! ? 
        IconButton(
          onPressed: (){
            HapticFeedback.heavyImpact();
            context.pop();
          }, 
          icon: Icon(leadingIcon)
        )
        :
        Icon(
          leadingIcon,
          color: colors.primary,
          size: size.width * 0.055,
        ),
      ),
      actions: actions,

      //* estilo
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
       
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity
          ),
          child: Container(
            // NO pongas color aquí
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary.withOpacity(glassOpacity),
                  colors.primary.withOpacity(glassOpacity * 0.7),
                ],
                
              ),
              // border: Border(
              //   bottom: BorderSide(
              //     // color: Colors.white.withOpacity(0.6),
              //     width: 1
              //   ),
              // ),
            ),
          )
        )
      )
    );
  }
  
  //* para que pueda asignar esto a una Appbar
  @override
  Size get preferredSize => const Size.fromHeight(60);
}