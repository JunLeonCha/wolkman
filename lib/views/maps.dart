import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/course/activity.dart';
import '../services/user/user-services.dart';
import 'package:get/get.dart';

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
  bool _isTracking = true; // Track whether the route is being recorded
  bool _isFirstPoint = true; // To check if it's the first point added
  bool _shouldFollowUser = true; // To control auto-centering
  double _currentZoom = 15.0; // Zoom level
  DateTime? startTime; // Start time of the journey
  List<Map<String, dynamic>> savedRoutes = []; // List to save journey data
  final ActivityServices activityServices = Get.put(ActivityServices());
  final UserServices userServices =
      UserServices(); // Create an instance of UserServices

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
      if (!_isTracking) return; // Stop tracking if paused

      LatLng newLocation = LatLng(position.latitude, position.longitude);

      // Record the start time if this is the first point
      if (_isFirstPoint) {
        startTime = DateTime.now();
      }

      // Calculate distance from last location, ignoring the first point
      if (routePoints.isNotEmpty && !_isFirstPoint) {
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
        _isFirstPoint = false; // After the first point is added

        if (_shouldFollowUser) {
          _mapController.move(currentLocation, _currentZoom); // Follow user
        }
      });
    });
  }

  // Toggle tracking for pause/resume
  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
    });
  }

  // Save route data and show a pop-up message
  void _endJourney(BuildContext context) async {
    if (routePoints.isNotEmpty) {
      DateTime endTime = DateTime.now();

      // Get the current user's profile ID dynamically
      final userDetails = await userServices.getUserDetails();
      String profileId = userDetails?['id']; // Use the ID from the user details

      // Prepare journey data
      Map<String, dynamic> journeyData = {
        'start_point': routePoints.first,
        'end_point': routePoints.last,
        'start_time': startTime,
        'end_time': endTime,
        'total_distance': totalDistance.toStringAsFixed(2),
      };

      savedRoutes.add(journeyData);

      // Log the data before sending to Supabase
      print('Inserting activity with the following data:');
      print('Time: ${endTime.toIso8601String()}');
      print(
          'Speed: ${double.parse((totalDistance / (endTime.difference(startTime!).inSeconds / 3600)).toStringAsFixed(2))}');
      print('Distance: ${double.parse(totalDistance.toStringAsFixed(2))}');
      print('Profile ID: $profileId');

      // Insert activity into Supabase
      await activityServices.insertActivity(
        time: endTime.toIso8601String(),
        speed: double.parse(
            (totalDistance / (endTime.difference(startTime!).inSeconds / 3600))
                .toStringAsFixed(2)),
        distance: double.parse(totalDistance.toStringAsFixed(2)),
      );

      // Show a pop-up message (SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journey data saved!')),
      );

      setState(() {
        routePoints.clear();
        totalDistance = 0.0;
        _isFirstPoint = true;
      });
    }
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
              zoom: _currentZoom,
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
            bottom: 120, // Adjust position so it's above the "End" button
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
                  // Distance display
                  Text(
                    'Distance: ${totalDistance.toStringAsFixed(2)} km',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // Icons and labels (Itinerary, Pause/Resume, Voice)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Column(
                        children: [
                          Icon(Icons.route),
                          Text('Itinerary'),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: _toggleTracking, // Toggle pause/resume
                            child: Column(
                              children: [
                                Icon(_isTracking
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                Text(_isTracking ? 'Pause' : 'Resume'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Column(
                        children: [
                          Icon(Icons.voice_chat),
                          Text('Voice'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // End journey button
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () => _endJourney(context), // End journey
              child: const Text('End Journey'),
            ),
          ),
        ],
      ),
    );
  }
}
