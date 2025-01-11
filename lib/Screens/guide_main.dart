import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_rait_new/Screens/homePage.dart';
import 'emergencycontacts.dart';
import 'fake_call.dart';
import 'generalsafety.dart';
import 'kawachBot.dart';
import 'selfdefence.dart';

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
                  initialCenter: LatLng(19.0760, 72.8777),
                  initialZoom: 13.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                ],
              ),
            ),

            // Legend
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem('High', Colors.red),
                  _buildLegendItem('Medium', Colors.orange),
                  _buildLegendItem('Low', Colors.yellow),
                  _buildLegendItem('Least', Colors.green),
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab(context, 'General Safety Tips', 'assets/general_safety.png', navigateTo: SafetyChecklistPage()),
                  _buildTab(context, 'Learn Self Defence', 'assets/self_defence.png', navigateTo: SelfDefencePage()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab(context, 'Emergency Contacts', 'assets/emergency_contact.png', navigateTo: Econtactpage()),
                  _buildTab(context, 'Talk with Kawach Bot', 'assets/bot.png', navigateTo: SafetySupport()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
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
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
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