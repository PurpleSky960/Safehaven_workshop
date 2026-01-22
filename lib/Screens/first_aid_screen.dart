import 'package:flutter/material.dart';

//  CHANGED: importing data & model instead of hardcoded content
import '../data/first_aid_data.dart';
import '../models/first_aid_model.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //  CHANGED: access structured first aid data
    final List<FirstAidModel> aidGuides = FirstAidData.guides;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.deepPurple, Colors.red],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("First Aid Guide"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:
        const BoxDecoration(color: Color.fromARGB(255, 37, 17, 73)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            //  CHANGED: removed hardcoded sections
            /*
            children: [
              _aidSection("Burns"),
              _aidSection("Bleeding"),
              _aidSection("Fractures"),
              _aidSection("CPR"),
              _aidSection("Shock"),
              _aidSection("Drowning"),
            ],
            */

            //  CHANGED: dynamically build cards from data
            children: aidGuides
                .map((guide) => _AidCard(guide: guide))
                .toList(),
          ),
        ),
      ),
    );
  }

//  CHANGED: old static UI method no longer needed
/*
  Widget _aidSection(String title) {
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
              "Do's and Don'ts",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text("Text here", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
  */
}

//  CHANGED: new reusable card widget driven by model
class _AidCard extends StatelessWidget {
  final FirstAidModel guide;

  const _AidCard({required this.guide});

  @override
  Widget build(BuildContext context) {
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
              guide.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(guide.content,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            const Text(
              "Do's and Don'ts",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              guide.doAndDont,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
