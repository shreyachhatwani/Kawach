import 'package:flutter/material.dart';

import 'login.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/signup.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Ready to protect yourself?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Let's get started!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Full name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Valid email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Strong Password just like you',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  const Expanded(
                    child: Text(
                      'By checking the box you agree to our Terms and Conditions.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  'Already a member? Log In',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
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
