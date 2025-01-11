import 'package:flutter/material.dart';

import 'bottomNavBar.dart';
import 'homePage.dart';


class DeactivatePage extends StatefulWidget {
  const DeactivatePage({Key? key}) : super(key: key);

  @override
  _DeactivatePageState createState() => _DeactivatePageState();
}

class _DeactivatePageState extends State<DeactivatePage> {
  TextEditingController _pinController = TextEditingController();
  bool _isPinCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deactivate SOS Mode'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the pin to deactivate SOS mode:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Pin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPin,
              child: const Text('Deactivate SOS'),
            ),
            if (!_isPinCorrect)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Incorrect PIN. Try again.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _checkPin() {
    if (_pinController.text == '1234') {
      setState(() {
        _isPinCorrect = true;
      });
      // Navigate back to MapPage() once the correct pin is entered
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Bottomnavbar()),
      );
    } else {
      setState(() {
        _isPinCorrect = false;
      });
    }
  }
}
