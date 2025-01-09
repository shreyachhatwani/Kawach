import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: FlutterMap(
          options: MapOptions(
            initialZoom: 30,
            maxZoom: 30,
            initialCenter: LatLng(19.2548,27.68466),
            // initialCameraFit: ,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              // Plenty of other options available!
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(19.2548,27.68466),
                  width: 80,
                  height: 80,
                  child: Icon(Icons.location_on_rounded,color: Colors.red,size: 45,),
                ),
              ],
            ),
          ],

        ),
      ),
    );
  }
}
