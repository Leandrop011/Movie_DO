import 'package:flutter/material.dart';

class CustomSettingsCards extends StatelessWidget {

  final String type;
  final Icon icon;

  const CustomSettingsCards({super.key, required this.type, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          
        },
        child: ListTile(
          title: Text(type),
          leading: icon,
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}