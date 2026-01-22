import 'package:flutter/material.dart';
import 'package:safehaven/Screens/contacts_screen.dart';
import 'package:safehaven/Screens/wiki_screen.dart';
import 'package:safehaven/Screens/first_aid_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share_plus/share_plus.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;

class NearbyPlace {
  final String name;
  final String address;
  final String type;
  final String distance;

  NearbyPlace({
    required this.name,
    required this.address,
    required this.type,
    required this.distance,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final Map<String, List<NearbyPlace>> _dummyNearbyData = {
    "Hospitals": [
      NearbyPlace(
        name: "Pokémon Center",
        address: "Cerulean City",
        type: "hospital",
        distance: "1.2 km",
      ),
      NearbyPlace(
        name: "Saffron Medical Hub",
        address: "Saffron City",
        type: "hospital",
        distance: "2.8 km",
      ),
    ],
    "Police Stations": [
      NearbyPlace(
        name: "Officer Jenny HQ",
        address: "Viridian City",
        type: "police",
        distance: "0.9 km",
      ),
      NearbyPlace(
        name: "Pewter Law Unit",
        address: "Pewter City",
        type: "police",
        distance: "3.4 km",
      ),
    ],
    "Fire Stations": [
      NearbyPlace(
        name: "Cinnabar Fire Dept",
        address: "Cinnabar Island",
        type: "fire",
        distance: "5.1 km",
      ),
      NearbyPlace(
        name: "Lavender Safety Unit",
        address: "Lavender Town",
        type: "fire",
        distance: "2.0 km",
      ),
    ],
    "Shelters": [
      NearbyPlace(
        name: "Mt. Moon Shelter",
        address: "Route 4",
        type: "shelter",
        distance: "6.7 km",
      ),
      NearbyPlace(
        name: "Celadon Community Hall",
        address: "Celadon City",
        type: "shelter",
        distance: "1.9 km",
      ),
    ],
  };

  String _currentLocation = "Fetching...";
  Position? _currentPosition;

  // List<NearbyPlace> _nearbyPlaces = [];
  // bool _loadingPlaces = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _currentLocation = "Location disabled");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _currentLocation = "Permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _currentLocation = "Permission permanently denied");
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;

    setState(() {
      _currentPosition = position;
      _currentLocation = "${place.locality}, ${place.administrativeArea}";
    });

    //_fetchNearbyPlaces();
  }

  // Future<void> _fetchNearbyPlaces() async {
  //   if (_currentPosition == null) return;

  //   setState(() => _loadingPlaces = true);

  //   final lat = _currentPosition!.latitude;
  //   final lon = _currentPosition!.longitude;

  //   const amenities = ["hospital", "police", "fire_station", "shelter"];

  //   final query =
  //       '''
  // [out:json];
  // (
  //   node["amenity"~"${amenities.join('|')}"](around:3000,$lat,$lon);
  // );
  // out;
  // ''';

  //   try {
  //     final response = await http.post(
  //       Uri.parse("https://overpass-api.de/api/interpreter"),
  //       body: {"data": query},
  //     );

  //     if (response.statusCode != 200) return;

  //     final data = json.decode(response.body);
  //     final List elements = data["elements"];

  //     final places = elements.map((e) {
  //       return NearbyPlace(
  //         name: e["tags"]?["name"] ?? "Unnamed",
  //         type: e["tags"]?["amenity"] ?? "unknown",
  //         lat: e["lat"],
  //         lon: e["lon"],
  //       );
  //     }).toList();

  //     setState(() => _nearbyPlaces = places);
  //   } catch (_) {
  //     debugPrint("Failed to fetch nearby places");
  //   } finally {
  //     setState(() => _loadingPlaces = false);
  //   }
  // }

  void _shareLocation() {
    if (_currentPosition == null) return;

    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;

    final url = "https://www.google.com/maps?q=$lat,$lon";
    Share.share("My current location: $url");
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeBody();
      case 1:
        return const ContactsScreen();
      case 2:
        return const WikiScreen();
      default:
        return _buildHomeBody();
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _shareImageWithLens(File image) async {
    await Share.shareXFiles([XFile(image.path)], text: "Open with Google Lens");
  }

  // Capture image and store locally
  Future<void> _captureAndSaveImage({bool shareAfter = false}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesDirPath = "${appDir.path}/captured_images";

    final Directory imagesDir = Directory(imagesDirPath);
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final File savedImage = await File(
      image.path,
    ).copy("$imagesDirPath/${DateTime.now().millisecondsSinceEpoch}.jpg");

    debugPrint("Image saved to: ${savedImage.path}");

    if (shareAfter) {
      await _shareImageWithLens(savedImage);
    }
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
                title: const Text("Capture Image"),
                subtitle: const Text("Saved locally"),
                onTap: () {
                  Navigator.pop(context);
                  _captureAndSaveImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text("Search with Google Lens"),
                subtitle: const Text("Uses share menu"),
                onTap: () async {
                  Navigator.pop(context);
                  await _captureAndSaveImage(shareAfter: true);
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
              onTap: _shareLocation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Location",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Text(
                    _currentLocation,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
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
        children: _dummyNearbyData.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(entry.key),
              SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    return _nearbyPlaceCard(entry.value[index]);
                  },
                ),
              ),
            ],
          );
        }).toList(),
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

  // Widget _serviceTile(String name, IconData icon) {
  //   return Card(
  //     elevation: 3,
  //     margin: const EdgeInsets.symmetric(vertical: 6),
  //     color: Colors.transparent,
  //     child: Container(
  //       decoration: const BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.bottomLeft,
  //           end: Alignment.topRight,
  //           colors: [Colors.pink, Colors.red],
  //         ),
  //         borderRadius: BorderRadius.all(Radius.circular(12)),
  //       ),
  //       child: ListTile(
  //         leading: Icon(icon, color: Colors.white),
  //         title: Text(
  //           name,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         trailing: IconButton(
  //           icon: const Icon(Icons.navigation, color: Colors.white),
  //           onPressed: () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text("Map feature coming soon")),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _nearbyPlaceCard(NearbyPlace place) {
    IconData icon;

    switch (place.type) {
      case "hospital":
        icon = Icons.add;
        break;
      case "police":
        icon = Icons.local_police;
        break;
      case "fire":
        icon = Icons.local_fire_department;
        break;
      case "shelter":
        icon = Icons.home;
        break;
      default:
        icon = Icons.place;
    }

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.pink, Colors.red],
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                place.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                place.address,
                style: const TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                place.distance,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}