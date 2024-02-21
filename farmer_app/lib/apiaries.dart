import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyScreen(),
//     );
//   }
// }

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool showSection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toggle Screen Sections'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                showSection = !showSection;
              });
            },
            child: Text(showSection ? 'Hide Section' : 'Show Section'),
          ),
          SizedBox(height: 20),
          if (showSection)
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'This is the section that can be toggled',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
