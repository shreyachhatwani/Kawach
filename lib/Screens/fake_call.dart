import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class FakeCallPage extends StatelessWidget {
  final String callAgentNumber = 'tel:+13238142763';// Replace with your Dialogflow agent number

  FakeCallPage({Key? key}) : super(key: key);

  Future<void> _launchFakeCall(BuildContext context) async {
    final Uri callUri = Uri.parse(callAgentNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to initiate a fake call.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Fake Call'),
          content: const Text('Do you want to start a fake call?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Press "Call Now" to initiate a fake call.'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _launchFakeCall(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Press "Call Now" to initiate a fake call.\nYou can talk about anything under the sky in English to the agent.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showConfirmationDialog(context),
              child: const Text('Call Now'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
