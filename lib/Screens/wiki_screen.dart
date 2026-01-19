import 'package:flutter/material.dart';

class WikiScreen extends StatelessWidget {
  const WikiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section("Earthquake"),
          _section("Flood"),
          _section("Fire"),
          _section("Cyclone"),
          _section("Landslide"),
          _section("Medical Emergency"),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.pink, Colors.red],
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text("Text here", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            const Text(
              "Read more on Wikipedia",
              style: TextStyle(
                color: Colors.white70,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
