import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../color/colors.dart';
import 'ChatPage.dart';
import 'fake_call.dart';
import 'guide_main.dart';
import 'homePage.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});
  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  final FlutterTts _flutterTts = FlutterTts();
  bool _speechEnabled = false;
  final SpeechToText _speechToText = SpeechToText();

  static List<Widget> _pages = <Widget>[
    Homepage(),
    FakeCallPage(),
    ChatPage(),
    GuidePage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
    _startShakeDetection();
    initSpeech();
  }
  @override
  void dispose() {
    _stopShakeDetection();
    super.dispose();
  }
  Future<void> _checkAndRequestPermissions() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(result) {
    String wordsSpoken = result.recognizedWords.toLowerCase();
    if (wordsSpoken.contains('help help')) {
      _sendSOS();
    } else {
      _flutterTts.speak("Command not recognized. Please try again.");
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _sendSOS() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool hasPermission = await isPermissionGranted();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS permission is required to send SOS messages'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Position position = await _getCurrentLocation();
      String message =
          "SOS! I need help! This is an emergency message. My location: "
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      await sendSms('8850990106', message);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS message sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error sending SOS: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send SOS message. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: _speechToText.isListening ? _stopListening : _startListening,
            child: const Text('Kawach')),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          await _sendSOS();
        },
        child: _isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.sos, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call, color: Colors.white),
            label: 'FakeCall',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.crisis_alert, color: Colors.white),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined, color: Colors.white),
            label: 'guide',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
      ),
    );
  }

  getPermission() async => await [Permission.sms].request();

  Future<bool> isPermissionGranted() async => await Permission.sms.status.isGranted;

  Future<void> sendSms(String phoneNumber, String message) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message);
    if (result == SmsStatus.sent) {
      print('Sent');
    } else {
      print('Failed');
    }
  }


  bool _isShakeDetected = false;
  StreamSubscription? _accelerometerSubscription;

  void _startShakeDetection() {
    const double shakeThreshold = 15.0;

    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double acceleration = event.x * event.x + event.y * event.y + event.z * event.z;
      if (acceleration > shakeThreshold && !_isShakeDetected) {
        _isShakeDetected = true;
        _sendSOS();  // Call your SOS sending method
      }
    });
  }

  void _stopShakeDetection() {
    _accelerometerSubscription?.cancel();
    _isShakeDetected = false;
  }

}


