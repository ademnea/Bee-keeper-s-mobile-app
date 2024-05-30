import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:farmer_app/Services/notifi_service.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Center(
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
                                    'Notifications',
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
                              NotificationService().showNotification(
                                  title: 'Hive 2',
                                  body:
                                      'Temperature above 40°C! please check this hive.');
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
                              LineIcons.bellAlt,
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

                          const Text('Notifications'),
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
            const Padding(
              padding: EdgeInsets.only(),
            ),
          ],
        ),
      ),
//bottom navigation bar.
    );
  }
}
