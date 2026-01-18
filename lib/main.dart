import 'package:flutter/material.dart';
import 'package:safehaven/Screens/home_screen.dart';

void main() {
  runApp(const SafehavenApp());
}

class SafehavenApp extends StatelessWidget {
  const SafehavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
