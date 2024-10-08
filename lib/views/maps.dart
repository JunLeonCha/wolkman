import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  // User's current location
  LatLng currentLocation = LatLng(48.858844, 2.294351); // Initial coordinates
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Check and request location permission
    _checkLocationPermission();

    // Get real-time location
    _getCurrentLocation();
  }

  // Location permission check
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are on
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services off.');
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissions denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissions permanently denied.');
    }
  }

  // Get live location updates
  void _getCurrentLocation() {
    Geolocator.getPositionStream().listen((Position position) {
      // Update map with new GPS coordinates
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(currentLocation, 15.0); // Zoom level 15
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OpenStreetMap')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: currentLocation,
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: currentLocation,
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on, size: 40, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
