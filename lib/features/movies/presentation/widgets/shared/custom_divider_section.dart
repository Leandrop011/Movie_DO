// * WIDGET DIVIDER QUE LO USAMOS REPETIDAMENTE EN LA SCREEN
import 'package:flutter/material.dart';

class DividerSectionsView extends StatelessWidget {
  const DividerSectionsView({
    super.key, 
    required this.fount,
  });

  final bool fount;

  @override
  Widget build(BuildContext context) {
    return Divider(
      endIndent: 10,
      indent: 10,
      thickness: 1,
      color: fount ? Colors.white38 : Colors.black45,
      radius: BorderRadius.circular(50),
    );
  }
}