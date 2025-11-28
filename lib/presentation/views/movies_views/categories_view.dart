import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories View'),
      ),
      body: FadeInRight(
        child: Center(child: Text('Categorias'),)
      )
    );
  }
}