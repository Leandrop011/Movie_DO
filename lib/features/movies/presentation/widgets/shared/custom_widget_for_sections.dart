import 'package:flutter/material.dart';

class CustomWidgetForSections extends StatelessWidget {

  final Size size; 
  final ColorScheme colors;

  const CustomWidgetForSections({
    super.key, 
    required this.size, 
    required this.colors
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: size.width * 0.015,
        height: size.height * 0.03,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: colors.primary
        ),
      ),
    );
  }
}