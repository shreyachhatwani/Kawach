import 'package:flutter/material.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'homePage.dart';

class DeactivatePage extends StatefulWidget {
  const DeactivatePage({Key? key}) : super(key: key);

  @override
  _DeactivatePageState createState() => _DeactivatePageState();
}

class _DeactivatePageState extends State<DeactivatePage> {
  TextEditingController _pinController = TextEditingController();
  bool _isPinCorrect = false;

  // Function to check SMS permissions
  Future<bool> _checkPermission() async {
    final smsPermission = await Permission.sms.status;
    if (smsPermission.isGranted) {
      return true;
    } else {
      final status = await Permission.sms.request();
      return status.isGranted;
    }
  }

  // Function to send SMS
  Future<void> _sendSMS() async {
    List<String> phoneNumbers = [
      // Add your emergency contact numbers here
      "8879781985",  // Replace with actual phone numbers
      "7972627245"
    ];

    bool isPermissionGranted = await _checkPermission();

    if (isPermissionGranted) {
      for (String phoneNumber in phoneNumbers) {
        await BackgroundSms.sendMessage(
          phoneNumber: phoneNumber,
          message: "This was a false alarm and I am safe",
        ).then((result) {
          if (result == SmsStatus.sent) {
            print("SMS sent successfully to $phoneNumber");
          } else {
            print("Failed to send SMS to $phoneNumber");
          }
        });
      }
    } else {
      print("SMS permission not granted");
    }
  }

  void _checkPin() async {
    if (_pinController.text == '1234') {
      setState(() {
        _isPinCorrect = true;
      });

      // Send SMS when correct PIN is entered
      await _sendSMS();

      // Navigate back to MapPage() once the correct pin is entered
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } else {
      setState(() {
        _isPinCorrect = false;
      });
    }
  }

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
}