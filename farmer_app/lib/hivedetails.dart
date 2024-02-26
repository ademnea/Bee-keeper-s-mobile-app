import 'package:farmer_app/components/imageslider.dart';
import 'package:farmer_app/splashscreen.dart';
import 'package:farmer_app/components/notificationbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class HiveDetails extends StatefulWidget {
  const HiveDetails({super.key});

  @override
  State<HiveDetails> createState() => _HiveDetailsState();
}

class _HiveDetailsState extends State<HiveDetails> {
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
                                  'HiveName',
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
                  //image starts here
                  SizedBox(
                    width: double.infinity,
                    child: ImageSlider(),
                  ),

                  //first card
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        clipBehavior: Clip.antiAlias,

                        color: Colors
                            .brown[300], // Set the background color to gray
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            //row
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.developer_board_outlined,
                                    color: Colors.orange[700],
                                  ),
                                ),
                                const Text(
                                  'Device:',
                                  style: TextStyle(
                                    //fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Connected',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Splashscreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Check Monitor',
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        decoration: TextDecoration.underline,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),

                            Divider(
                              height: 1, // Set the height of the divider
                              color: Colors
                                  .grey[350], // Set the color of the divider
                              thickness: 2, // Set the thickness of the divider
                            ),

                            //row
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Splashscreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Harvesting time',
                                    style: TextStyle(
                                        color: Colors.white,
                                        // decoration: TextDecoration.underline,
                                        fontSize: 17),
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Splashscreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Feeding time',
                                    style: TextStyle(
                                        color: Colors.grey[200],
                                        // decoration: TextDecoration.underline,
                                        fontSize: 17),
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              child: TableCalendar(
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay: DateTime.now(),
                              ),
                            ),

                            Divider(
                              height: 1, // Set the height of the divider
                              color: Colors
                                  .grey[350], // Set the color of the divider
                              thickness: 2, // Set the thickness of the divider
                            ),

                            //notifications start here.
                            Container(
                              child: const Column(
                                children: [
                                  //notifications
                                  NotificationComponent(
                                    date: 'November 3, 2023',
                                    title: 'Device Malfunction',
                                    content:
                                        'The device has not communicated in 5 days, please check this hive.',
                                  ),
                                  NotificationComponent(
                                    date: 'November 3, 2023',
                                    title: 'Device Malfunction',
                                    content:
                                        'The device has not communicated in 5 days, please check this hive.',
                                  ),
                                ],
                              ),
                            ),
//notifications end
                            const Padding(
                              padding:
                                  EdgeInsets.only(left: 0, bottom: 22, top: 8),
                            ),
                          ],
                        ),
                      ),
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
