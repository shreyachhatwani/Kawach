import 'package:flutter/material.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'deactivatedSOS.dart';

class SOSActivatedPage extends StatefulWidget {
  const SOSActivatedPage({Key? key}) : super(key: key);

  @override
  State<SOSActivatedPage> createState() => _SOSActivatedPageState();
}

class _SOSActivatedPageState extends State<SOSActivatedPage> {
  final String emergencyNumber = '+918879781985';
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  Future<bool> _checkSmsPermission() async {
    final smsPermission = await Permission.sms.status;
    if (smsPermission.isGranted) {
      return true;
    } else {
      final status = await Permission.sms.request();
      return status.isGranted;
    }
  }

  Future<void> _sendSOSMessage() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
    }

    bool isPermissionGranted = await _checkSmsPermission();
    if (!isPermissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SMS permission not granted')),
      );
      return;
    }

    String locationLink = 'https://www.google.com/maps/search/?api=1&query=${_currentPosition?.latitude},${_currentPosition?.longitude}';
    String message = 'SOS! I need help! My location: $locationLink';

    try {
      var result = await BackgroundSms.sendMessage(
        phoneNumber: emergencyNumber,
        message: message,
      );

      if (result == SmsStatus.sent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SOS message sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send SOS message')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SOS Mode Activated"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/sos.png',
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const Text(
                'SOS Mode Activated',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: _sendSOSMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Send to Authority',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DeactivatePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Deactivate SOS Mode',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}