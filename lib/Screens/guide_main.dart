import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_rait_new/Screens/homePage.dart';

import 'fake_call.dart';
import 'selfdefence.dart';  // Add the import for SelfDefencePage

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map widget
            Container(
              height: 250,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(19.0760, 72.8777), // Example coordinates (Mumbai)
                  maxZoom: 10.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                ],
              ),
            ),

            // Legend Image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/legend.png', // Replace with your legend image
                height: 50,
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab(context, 'General Safety Tips', 'assets/general_safety.png'),
                  _buildTab(context, 'Learn Self Defence', 'assets/self_defence.png', navigateTo: SelfDefencePage()), // Navigate to SelfDefencePage
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab(context, 'Emergency Contacts', 'assets/emergency_contact.png'),
                  _buildTab(context, 'Talk with Kawach Bot', 'assets/bot.png'),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildTab(BuildContext context, String title, String imagePath, {Widget? navigateTo}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (navigateTo != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigateTo),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal spacing
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 8.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
