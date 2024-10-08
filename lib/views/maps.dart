import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  LatLng currentLocation =
      const LatLng(48.858844, 2.294351); // Initial location
  late MapController _mapController;
  List<LatLng> routePoints = []; // Store the points of the route
  double totalDistance = 0.0; // Store the total distance

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Check for location permission
    _checkLocationPermission();

    // Get real-time location
    _getCurrentLocation();
  }

  // Request and check location permission
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services off.');
    }

    // Check permission
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

  // Get current location in real-time and calculate distance
  void _getCurrentLocation() {
    Geolocator.getPositionStream().listen((Position position) {
      LatLng newLocation = LatLng(position.latitude, position.longitude);

      // Calculate distance from last location
      if (routePoints.isNotEmpty) {
        LatLng lastLocation = routePoints.last;
        double distanceInMeters = Geolocator.distanceBetween(
          lastLocation.latitude,
          lastLocation.longitude,
          newLocation.latitude,
          newLocation.longitude,
        );
        totalDistance += distanceInMeters / 1000; // Convert to kilometers
      }

      // Update location and route
      setState(() {
        currentLocation = newLocation;
        routePoints.add(newLocation); // Add to route
        _mapController.move(currentLocation, 15.0); // Zoom to 15
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OpenStreetMap')),
      body: Stack(
        children: [
          // Map widget
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: currentLocation,
              zoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: currentLocation,
                    builder: (ctx) => Container(
                      child: const Icon(Icons.location_on,
                          size: 40, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // UI overlay
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.8), // Semi-transparent background
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icons and labels (Itinerary, Pause, Voice)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.route),
                          Text('Itinerary'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.pause),
                          Text('Pause'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.volume_up),
                          Text('Voice'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Display total distance
                  Text(
                    'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  // Activity button
                  ElevatedButton(
                    onPressed: () {
                      // Handle button click
                    },
                    child: const Text('Start Activity'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
