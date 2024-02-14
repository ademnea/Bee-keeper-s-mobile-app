import 'package:farmer_app/getstarted.dart';
import 'package:farmer_app/hives.dart';
import 'package:farmer_app/login.dart';
import 'package:farmer_app/register.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import './home.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class navbar extends StatefulWidget {
  const navbar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _navbarState();
  }
}

class _navbarState extends State<navbar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Hives(),
    register(),
    GetStarted()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('MillionDollarBaby'),
      //   backgroundColor: Colors.green[800], // Set the background color
      // ),

      //the code below displays content for each page.
      // navigation bar is supposed to display here for all the pages,

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
                  text: 'Hives',
                ),
                GButton(
                  icon: LineIcons.shoppingBag,
                  text: 'Shop',
                ),
                GButton(
                  icon: LineIcons.users,
                  text: 'Community',
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
