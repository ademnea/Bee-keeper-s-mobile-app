import 'package:HPGM/components/hive_tips.dart';
import 'package:flutter/material.dart';
import 'package:HPGM/components/notificationbar.dart';

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
                                        fontFamily: "Sans",
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
                    const Center(
                      child: Column(
                        children: [
                          NotificationComponent(
                            date: 'June 18, 2024',
                            title: 'Honey Harvest season',
                            content:
                                'The Honey harvest season is here, check your hives and harvest the honey.',
                          ),

                          //second notification
                          NotificationComponent(
                            date: 'June 18 2024',
                            title: 'prototype 2 apiary temperature',
                            content:
                                'prototype 2 apiary temperature soaring above 30°C!, please check it out. supplementary feeding may be required.',
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Daily Hive Management Tips",
                              style: TextStyle(
                                  fontFamily: "Sans",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          //Start of the hive management tips
                          HiveTips(
                            title: 'Supplementary feeding',
                            content:
                                'When the temperature of a farm or hive is over 35°C, it is advisable to put a trough of water in the apiary to support your bees.',
                          ),
                          //Second tip.
                          HiveTips(
                            title: 'Honey harvesting',
                            content:
                                'During honey harvest seasons, more weight on a hive, could indicate that it is ready for harvest.',
                          ),
                          //third tip.
                          HiveTips(
                            title: 'Device connection',
                            content:
                                'When a hive shows \'device disconnected\', this may indicate potential problems with the hive connection. It is therefore advisable to contact the support team.',
                          ),
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
