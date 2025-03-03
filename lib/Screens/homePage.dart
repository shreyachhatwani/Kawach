import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share_plus/share_plus.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Position? _currentPosition;
  LatLng? _startLocation;
  LatLng? _endLocation;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best,  // Set to best accuracy
          distanceFilter: 5,  // Update every 5 meters
        ),
      ).listen((Position position) {
        setState(() {
          _currentPosition = position;
        });
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _getCoordinates(String location, bool isStart) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        setState(() {
          if (isStart) {
            _startLocation = LatLng(locations.first.latitude, locations.first.longitude);
          } else {
            _endLocation = LatLng(locations.first.latitude, locations.first.longitude);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finding location: $e')),
      );
    }
  }

  void _shareLocation() {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available. Please wait...')),
      );
      return;
    }
    final String locationMessage =
        'Here is my current location: https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    Share.share(locationMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialZoom: 8.0,
              minZoom: 3.0,
              maxZoom: 19.0,
              initialCenter: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : const LatLng(19.2548, 27.68466),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                maxZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  if (_currentPosition != null)
                    Marker(
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 45,
                      ),
                    ),
                  if (_startLocation != null)
                    Marker(
                      point: _startLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 45,
                      ),
                    ),
                  if (_endLocation != null)
                    Marker(
                      point: _endLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.flag,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                TextField(
                  controller: _startController,
                  decoration: InputDecoration(
                    labelText: 'Start Location',
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _getCoordinates(_startController.text, true),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _endController,
                  decoration: InputDecoration(
                    labelText: 'End Location',
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _getCoordinates(_endController.text, false),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.extended(
                onPressed: _shareLocation,
                label: const Text('Share Location'),
                icon: const Icon(Icons.share),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
