import 'package:flutter/material.dart';
import 'package:telephony_sms/telephony_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import '../color/colors.dart';
import 'ChatPage.dart';
import 'fake_call.dart';
import 'guide_main.dart';
import 'homePage.dart';
import 'reportPAge.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});
  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _selectedIndex = 0;
  final _telephonySMS = TelephonySMS();
  bool _isLoading = false;

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
  }

  Future<void> _checkAndRequestPermissions() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }
  }

  Future<bool> _requestSMSPermission() async {
    try {
      await _telephonySMS.requestPermission();
      return true;
    } catch (e) {
      print('Error requesting SMS permission: $e');
      // Try using permission_handler as fallback
      var status = await Permission.sms.request();
      return status.isGranted;
    }
  }

  Future<void> _sendSOS() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // First ensure we have permission
      bool hasPermission = await _requestSMSPermission();

      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS permission is required to send SOS messages'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Then send the SOS message
      await _telephonySMS.sendSMS(
        phone: "+918879781985",  // Your emergency number
        message: "SOS! I need help! This is an emergency message.",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS message sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error sending SOS: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
        title: const Text('Kawach'),
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
        onPressed: _isLoading ? null : _sendSOS,
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
}