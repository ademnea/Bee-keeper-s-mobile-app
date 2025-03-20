import 'dart:async';
import 'package:HPGM/getstarted.dart';
import 'package:HPGM/login.dart';
import 'package:HPGM/navbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    String? token = prefs.getString('authToken');

    if (isFirstTime) {
      // First-time user flow
      await prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStarted()),
      );
    } else {
      // Check session status
      if (token != null && token.isNotEmpty) {
        // Valid session exists
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => navbar(token: token)),
        );
      } else {
        // No valid session
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'lib/images/log-1.png',
            height: 200, // Added explicit height
          ),
        ),
      ),
    );
  }
}
