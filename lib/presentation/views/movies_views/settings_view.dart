import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings View'),
      ),
      body: Center(
        child: Text('Settings View'),
      ),
    );
  }
}