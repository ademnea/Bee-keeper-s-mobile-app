import 'package:HPGM/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  String _typedText = '';
  bool _isTyping = true;
  int _currentIndex = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _startTypingEffect();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _startTypingEffect() {
    const text =
        'Welcome to the Honey Productivity, Guide and Monitor app (HPGM), the all in one app that will help you track your hive productivity on the go!';
    const typingInterval =
        Duration(milliseconds: 100); 

    _typingTimer = Timer.periodic(typingInterval, (timer) {
      if (_currentIndex < text.length) {
        setState(() {
          _typedText = text.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        _typingTimer?.cancel();
        setState(() {
          _isTyping = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'lib/images/njuki.jpg', // Replace 'lib/images/njuki.jpg' with your image asset path
            fit: BoxFit.cover,
          ),
          // Opacity overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
          // Content
          Padding(
            padding:
                const EdgeInsets.only(top: 300.0), // Add space above the text
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Typing effect
                  SizedBox(
                    // height: 100, // Adjust height as needed
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          _typedText,
                          textAlign:
                              TextAlign.center, // Center text horizontally
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Sans',
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Cursor (if typing is complete)
                        if (!_isTyping) ...[
                          const Text(
                            ' ',
                            style: TextStyle(
                              fontSize: 24,
                              //fontWeight: FontWeight.bold,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Spacer to push the button to the bottom
                  const Spacer(),
                  // Button at the bottom
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 206, 109, 40), // RGB color
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height:
                        45, // Optional: Add some space between the button and the bottom edge
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
