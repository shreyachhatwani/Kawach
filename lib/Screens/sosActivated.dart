import 'package:flutter/material.dart';

import 'deactivatedSOS.dart';


class SOSActivatedPage extends StatelessWidget {
  const SOSActivatedPage({Key? key}) : super(key: key);

  final String emergencyNumber = '+918879781985'; // For now, use a random number

  // Future<void> _sendSOSMessage() async {
  //   final Telephony telephony = Telephony.instance;
  //   String message = 'SOS! I need help!';
  //   // For now, you can send a generic SOS message.
  //   await telephony.sendSms(to: emergencyNumber, message: message);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SOS Mode Activated")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add your SOS image here
            Image.asset('assets/sos.png', height: 200), // Placeholder image

            const SizedBox(height: 20),
            const Text(
              'SOS Mode Activated',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // const SizedBox(height: 40),
            // ElevatedButton(
            //   onPressed: _sendSOSMessage,
            //   child: const Text('Send SOS Message to Authorities'),
            // ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeactivatePage()),
                );
              },
              child: const Text('Deactivate SOS Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
