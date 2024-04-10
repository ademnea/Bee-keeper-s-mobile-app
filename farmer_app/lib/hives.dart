import 'package:farmer_app/hivedetails.dart';
import 'package:farmer_app/splashscreen.dart';
import 'package:farmer_app/components/graphs.dart';
import 'package:flutter/material.dart';

class Hives extends StatefulWidget {
  const Hives({super.key});

  @override
  State<Hives> createState() => _HivesState();
}

class _HivesState extends State<Hives> {
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
                      height: 150,
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
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.chevron_left_rounded,
                                      color: Color.fromARGB(255, 206, 109, 40),
                                      size: 65,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                const Text(
                                  'Hives',
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
                    child: SizedBox(
                      width: 350,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors
                            .brown[300], // Set the background color to gray
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            //table
                            Table(
                              children: [
                                TableRow(
                                  children: [
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'Hive: 2 North',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              // color: Colors.grey[
                                              //  300], // Background color
                                            ),
                                            child: Text(
                                              'Healthy',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange[700]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HiveDetails(),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'More Details',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ))),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.orange[700],
                                            ),
                                            const Text(
                                              'Mubende',
                                              style: TextStyle(
                                                //fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(0.0),
                                      ),
                                    ),
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(0.0),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.developer_board_outlined,
                                              color: Colors.orange[700],
                                            ),
                                            const Text(
                                              'Device:',
                                              style: TextStyle(
                                                //fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            child: Text(
                                              'Connected',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[700]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 22),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.hexagon,
                                    color: Colors.orange[700],
                                  ),
                                  const Text(
                                    'Recent Harvests',
                                    style: TextStyle(
                                      //fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    '12/04/24  |  12kg',
                                    style: TextStyle(
                                      //fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Padding(
                              padding:
                                  EdgeInsets.only(left: 0, bottom: 22, top: 8),
                              child: Text(
                                'check monitor',
                              ),
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

                  Container(
                    height: 20,
                  ),
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
