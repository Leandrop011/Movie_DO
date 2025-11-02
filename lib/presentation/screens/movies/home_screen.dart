import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/config/constants/environment.dart';

class HomeScreen extends StatelessWidget {

  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),

      body: Center(
        child: Text(Environment.movieDBKey),
      ),
    );
  }
}