import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Position? _currentPosition;
  final List<LatLng> _threateningRegions = [
    LatLng(19.2548, 27.68466),
    // Add more threatening regions here
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
        _checkThreateningRegion();
      });
    });
  }

  void _checkThreateningRegion() {
    for (var region in _threateningRegions) {
      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        region.latitude,
        region.longitude,
      );
      if (distance < 100) { // within 100 meters
        _showAlert();
        break;
      }
    }
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Safety Alert'),
          content: Text('You have entered a threatening region!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialZoom: 14,  // Increased initial zoom level
          maxZoom: 19,
          initialCenter: _currentPosition != null
              ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
              : LatLng(19.2548, 27.68466),
         
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            maxZoom: 19,


          ),
          MarkerLayer(
            markers: _currentPosition != null
                ? [
              Marker(
                point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                width: 80,
                height: 80,
                child: Icon(Icons.directions_walk, color: Colors.blue, size: 45),
              ),
            ]
                : [],
          ),
        ],
      ),
    );
  }
}
