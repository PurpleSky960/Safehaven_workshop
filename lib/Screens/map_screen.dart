import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;

  final Set<Marker> _markers = {};

  List<Map<String, dynamic>> hospitals = [];
  List<Map<String, dynamic>> policeStations = [];
  List<Map<String, dynamic>> shelters = [];

  static const String apiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentLocation = LatLng(pos.latitude, pos.longitude);

    await _fetchNearbyPlaces("hospital");
    await _fetchNearbyPlaces("police");
    await _fetchNearbyPlaces("shelter");

    setState(() {});
  }

  // ================= PLACES API =================

  Future<void> _fetchNearbyPlaces(String type) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${_currentLocation!.latitude},${_currentLocation!.longitude}"
        "&radius=3000&type=$type&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    for (var place in data["results"]) {
      final location = place["geometry"]["location"];
      final latLng = LatLng(location["lat"], location["lng"]);

      _markers.add(
        Marker(
          markerId: MarkerId(place["place_id"]),
          position: latLng,
          infoWindow: InfoWindow(title: place["name"]),
        ),
      );

      final entry = {
        "name": place["name"],
        "lat": location["lat"],
        "lng": location["lng"],
      };

      if (type == "hospital") hospitals.add(entry);
      if (type == "police") policeStations.add(entry);
      if (type == "shelter") shelters.add(entry);
    }
  }

  // ================= MAP SNAPSHOT =================

  Future<void> _saveMapSnapshot() async {
    if (_mapController == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/map_snapshot.txt");

    final cameraPosition = await _mapController!.getVisibleRegion();
    await file.writeAsString(cameraPosition.toString());
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentLocation!,
        zoom: 14,
      ),
      myLocationEnabled: true,
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
      },
      onCameraIdle: _saveMapSnapshot,
    );
  }
}
