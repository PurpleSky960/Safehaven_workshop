import 'package:flutter/material.dart';
import 'package:safehaven/Screens/contacts_screen.dart';
import 'package:safehaven/Screens/wiki_screen.dart';
import 'package:safehaven/Screens/first_aid_screen.dart';
import 'package:safehaven/Screens/map_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

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

  final ImagePicker _picker = ImagePicker();

  Future<void> _openGoogleLens() async {
    final Uri lensUri = Uri.parse("https://lens.google.com/");

    if (await canLaunchUrl(lensUri)) {
      await launchUrl(lensUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch Google Lens";
    }
  }

  // Capture image and store locally
  Future<void> _captureAndSaveImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesDirPath = "${appDir.path}/captured_images";

    final Directory imagesDir = Directory(imagesDirPath);
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final String newPath =
        "$imagesDirPath/${DateTime.now().millisecondsSinceEpoch}.jpg";

    await File(image.path).copy(newPath);

    debugPrint("Image saved to: $newPath");
  }

  // Bottom sheet options
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
                title: const Text("Open Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _captureAndSaveImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text("Open Google Lens"),
                onTap: () {
                  Navigator.pop(context);
                  _openGoogleLens();
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: const Color.fromARGB(255, 37, 17, 73)),
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ================= TOP BAR =================

  PreferredSizeWidget _buildTopBar() {
    return AppBar(
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
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
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
              onTap: () {},
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

          // Logo
          const Text(
            "SH",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          // Camera
          IconButton(
            icon: const Icon(Icons.camera_alt),
            color: Colors.white,
            onPressed: () {
              _showImageSourceOptions(context);
            },
          ),

          // First Aid
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Colors.deepPurple, Colors.red],
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts, color: Colors.white),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, color: Colors.white),
            label: "Wiki",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.white),
            label: "Map",
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // ================= HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _placeholderCard(String text) {
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
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _serviceTile(String name, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
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
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.navigation, color: Colors.white),
            onPressed: () {
              // open map tab
            },
          ),
        ),
      ),
    );
  }
}
