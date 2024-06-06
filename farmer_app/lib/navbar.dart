import 'package:HPGM/Notifications.dart';
import 'package:HPGM/apiaries.dart';
import 'package:HPGM/login.dart';
import 'package:HPGM/records.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import './home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class navbar extends StatefulWidget {
  String token;
  navbar({Key? key, required this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _navbarState();
  }
}

class _navbarState extends State<navbar> {
  //let me intialize the state and widget required variables here.
  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Home(
        token: widget.token,
        notify: false,
      ),
      Apiaries(
        token: widget.token,
      ),
      const Notifications(),
      const Records(),
      //MyScreen(), //to use in debugging the toggler.
    ];
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      //bottom navbar starts from here.

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.orange, // Set active icon color
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 600),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black, // Set default icon color
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.archive,
                  text: 'Apiaries',
                ),
                GButton(
                  icon: LineIcons.bell,
                  text: 'Notifications',
                ),
                GButton(
                  icon: LineIcons.folder,
                  text: 'Records',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
