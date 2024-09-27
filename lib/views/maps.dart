import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  // La position actuelle de l'utilisateur
  LatLng currentLocation = LatLng(48.858844, 2.294351); // Coordonnées initiales (Tour Eiffel)
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Vérifier et demander la permission de localisation
    _checkLocationPermission();

    // Suivre les changements de position
    _getCurrentLocation();
  }

  // Vérification des permissions de localisation
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    // Vérifie les permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Les permissions de localisation sont refusées de façon permanente.');
    }
  }

  // Obtenir la localisation en temps réel
  void _getCurrentLocation() {
    Geolocator.getPositionStream().listen((Position position) {
      // Met à jour la position de la carte avec les nouvelles coordonnées GPS
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(currentLocation, 15.0);  // Zoom à 15 sur la nouvelle position
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carte OpenStreetMap')),
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
