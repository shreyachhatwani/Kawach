import 'package:flutter/material.dart';
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

  static List<Widget> _pages = <Widget>[
    Homepage(),
    FakeCallPage(),
    ChatPage(),
    GuidePage(),
  ];

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
                // Navigate to Home Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
            ),
            // Add other menu items here
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          // Action for the floating button
        },
        child: Icon(Icons.sos,color: Colors.white,),
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



