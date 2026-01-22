import 'package:flutter/material.dart';

//  CHANGED: added url launcher + data & model imports
import 'package:url_launcher/url_launcher.dart';
import '../data/guide_data.dart';
import '../models/guide_model.dart';

class WikiScreen extends StatelessWidget {
  const WikiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //  CHANGED: access structured guide data
    final List<GuideModel> guides = GuideData.disasterGuides;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        //  CHANGED: removed hardcoded sections
        /*
        children: [
          _section("Earthquake"),
          _section("Flood"),
          _section("Fire"),
          _section("Cyclone"),
          _section("Landslide"),
          _section("Medical Emergency"),
        ],
        */

        //  CHANGED: dynamically build cards from data
        children: guides
            .map((guide) => _GuideCard(guide: guide))
            .toList(),
      ),
    );
  }

//  CHANGED: old static section method removed
/*
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
  */
}

//  CHANGED: new reusable card widget using model + features
class _GuideCard extends StatelessWidget {
  final GuideModel guide;

  const _GuideCard({required this.guide});

  //  CHANGED: open Wikipedia link
  Future<void> _launchWiki() async {
    final Uri url = Uri.parse(guide.wikiUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  //  CHANGED: save-for-offline placeholder feature
  void _saveForOffline(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${guide.title} saved for offline reading!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.transparent, // same styling
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
            // Title from data
            Text(
              guide.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Description from data
            Text(
              guide.description,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            //  CHANGED: action buttons added
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _saveForOffline(context),
                  icon: const Icon(Icons.bookmark_border,
                      color: Colors.white70),
                  label: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _launchWiki,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                  ),
                  icon: const Icon(Icons.public, size: 16),
                  label: const Text("Wiki"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
