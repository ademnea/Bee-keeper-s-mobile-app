import 'package:farmer_app/components/graphs.dart';
import 'package:farmer_app/media.dart';
import 'package:farmer_app/temperature.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class Humidity extends StatefulWidget {
  const Humidity({super.key});

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
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
                                'Monitors',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
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
                Container(
                  height: 1000,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.brown[300], // Set the background color here
                    // borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
//container components begin.
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: TextButton(
                              onPressed: () {
                                // Button pressed action
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Temperature(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: Colors.grey[300],
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Temperature',
                                    style: TextStyle(
                                      color:
                                          Colors.black, // Set text color here
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //second button

                          Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Button pressed action
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: Colors.orange[400],
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Humidity',
                                    style: TextStyle(
                                      color:
                                          Colors.black, // Set text color here
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //third button
                          TextButton(
                            onPressed: () {
                              // Button pressed action
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Media(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.grey[300],
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Media',
                                  style: TextStyle(
                                    color: Colors.black, // Set text color here
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //buttons end
                        ],
                      ),
                      // const Text('Navigation'),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Humidity Vs Time',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[300]),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                LineIcons.alternateCloudDownload,
                                color: Colors.white,
                                size: 30,
                              ),
                              label: const Text('')),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Button pressed action
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.grey[300],
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.calendar_today, // Add your icon here
                                  color: Colors.black, // Set icon color here
                                ),
                                SizedBox(
                                    width:
                                        8), // Add some space between the icon and text
                                Text(
                                  'Choose Date Range',
                                  style: TextStyle(
                                    color: Colors.black, // Set text color here
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ), // end of buttons row.
                      //start of the graph
                      Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: const SizedBox(
                          width: double.infinity, // Adjust width as needed
                          height: 550, // Adjust height as needed
                          child: Graphs(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
