//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/presentation/widgets/shared/custom_categories_masonry.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories View'),
      ),
      body: CustomCategoriesMasonry()
    );
  }
}