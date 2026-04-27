import 'package:flutter/material.dart';
import 'package:movies_app/config/theme/theme.dart';

class CustomAppCard extends StatelessWidget {
  final Widget child;
  final ColorScheme colors;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap; //* para e onpressed

  const CustomAppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.onTap, 
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: colors.primary.withOpacity(0.27),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    // ? SI LA FUNCION ONTAP ES NULL, SOLO RETORNA LA CARD
    if (onTap == null) return card;

    // ? PERO SINO RETORNA UNA CARD CON FUNCION DEL TAP
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: card,
      ),
    );
  }
}
