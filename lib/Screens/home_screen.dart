import 'package:flutter/material.dart';
import 'package:safehaven/Screens/contacts_screen.dart';
import 'package:safehaven/Screens/wiki_screen.dart';
import 'package:safehaven/Screens/first_aid_screen.dart';
import 'package:safehaven/Screens/map_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeBody();
      case 1:
        return const ContactsScreen();
      case 2:
        return const WikiScreen();
      case 3:
        return const MapScreen();
      default:
        return _buildHomeBody();
    }
  }

  Future<void> _openGoogleLens(File imageFile) async {
    final Uri lensUri = Uri.parse("https://lens.google.com/upload");

    if (await canLaunchUrl(lensUri)) {
      await launchUrl(lensUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch Google Lens";
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      _openGoogleLens(File(image.path));
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTopBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ================= TOP BAR =================

  PreferredSizeWidget _buildTopBar() {
    return AppBar(
      backgroundColor: Colors.black,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Profile picture + online indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green, // online
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Location
          Expanded(
            child: GestureDetector(
              onTap: () {
                // share live location later
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Current Location",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Text(
                    "Location",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Small logo placeholder
          const Text(
            "SH",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          // Camera / scanner
          IconButton(
            icon: const Icon(Icons.camera_alt),
            color: Colors.white,
            onPressed: () {
              _showImageSourceOptions(context);
            },
          ),

          // First aid codex
          IconButton(
            icon: const Icon(Icons.medical_services),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FirstAidScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= HOME BODY =================

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Weather & Forecast"),
          _placeholderCard("Sunny • 32°C\nNext 48 hrs forecast"),

          _sectionTitle("Alerts & Warnings"),
          _placeholderCard("No active alerts\nLast updated: 10:30 AM"),

          _sectionTitle("Area News"),
          _placeholderCard("Road closure near Ring Road\nRelief camp opened"),

          _sectionTitle("Nearby Services"),
          _serviceTile("Hospital", Icons.local_hospital),
          _serviceTile("Police Station", Icons.local_police),
          _serviceTile("Fire Station", Icons.local_fire_department),
          _serviceTile("Shelter", Icons.home),
        ],
      ),
    );
  }

  // ================= BOTTOM NAV =================

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Contacts"),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Wiki"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
      ],
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.grey,
    );
  }

  // ================= HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _placeholderCard(String text) {
    return Card(
      elevation: 2,
      child: Padding(padding: const EdgeInsets.all(16), child: Text(text)),
    );
  }

  Widget _serviceTile(String name, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent),
        title: Text(name),
        trailing: IconButton(
          icon: const Icon(Icons.navigation),
          onPressed: () {
            // open map tab
          },
        ),
      ),
    );
  }
}
