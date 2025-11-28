import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites View'),
      ),
      body: FadeInRight(
        child: Center(child: Text('Favoritos'),)
      ),
    );
  }
}