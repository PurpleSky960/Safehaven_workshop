import 'package:flutter/material.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("First Aid Guide"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _aidSection("Burns"),
            _aidSection("Bleeding"),
            _aidSection("Fractures"),
            _aidSection("CPR"),
            _aidSection("Shock"),
            _aidSection("Drowning"),
          ],
        ),
      ),
    );
  }

  Widget _aidSection(String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Text here"),
            const SizedBox(height: 8),
            const Text("Do's and Don'ts"),
            const SizedBox(height: 4),
            const Text("Text here"),
          ],
        ),
      ),
    );
  }
}
