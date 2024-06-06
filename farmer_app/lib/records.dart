import 'package:HPGM/components/imageslider.dart';
import 'package:HPGM/splashscreen.dart';
import 'package:HPGM/components/notificationbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  SizedBox(
                      height: 120,
                      width: 2000,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.orange.withOpacity(0.8),
                                  Colors.orange.withOpacity(0.6),
                                  Colors.orange.withOpacity(0.4),
                                  Colors.orange.withOpacity(0.2),
                                  Colors.orange.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          //image starts here
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Row(
                              children: [
                                Container(
                                  child: const Icon(
                                    Icons.chevron_left_rounded,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                    size: 65,
                                  ),
                                ),
                                const SizedBox(
                                  width: 90,
                                ),
                                const Text(
                                  'Records',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 206, 109, 40),
                                  size: 65,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),

                  //first card
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Button pressed action
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.white, // Set background color to white
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50.0), // Make it a circle
                              ),
                            ),
                          ),
                          child: const Icon(
                            LineIcons.plusCircle,
                            size: 65, // Adjust icon size as needed
                            color: Color.fromARGB(
                              255,
                              206,
                              109,
                              40,
                            ), // Adjust icon color as needed
                          ),
                        ),
                        //end of textbutton

                        const Text('Record New Harvest'),
                      ],
                    ),
                  ),

                  Container(
                    height: 20,
                  ),
                  // Add other cards here
                ],
              ),
            ),
          ),
        ),
      ),
//bottom navigation bar.
    );
  }
}
