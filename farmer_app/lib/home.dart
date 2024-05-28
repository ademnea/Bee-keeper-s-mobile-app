import 'package:farmer_app/components/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //list of the data.
  List<double> weeklySummary = [
    80.40,
    2.50,
    42.42,
    10.50,
    100.20,
    68.99,
    90.10,
  ];

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
                      height: 200,
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
                                  child: Image.asset(
                                    'lib/images/log-1.png',
                                    height: 80,
                                    width: 80,
                                  ),
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

                          //second row.

                          Padding(
                            padding: const EdgeInsets.only(top: 150.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Grey color
                                      borderRadius: BorderRadius.circular(
                                          20), // Pill-like shape
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.house,
                                          color:
                                              Color.fromARGB(255, 63, 59, 59),
                                        ),
                                        Text(
                                          'Farms: 4',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Grey color
                                      borderRadius: BorderRadius.circular(
                                          20), // Pill-like shape
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.house,
                                          color:
                                              Color.fromARGB(255, 63, 59, 59),
                                        ),
                                        Text(
                                          'Hives: 24',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Heaviest Hive',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Center(
                    child: Container(
                      height: 250,
                      width: 300,
                      child: LiquidLinearProgressIndicator(
                        value: 0.65, // Defaults to 0.5.
                        valueColor: const AlwaysStoppedAnimation(Colors
                            .orange), // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors
                            .white, // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.brown,
                        borderWidth: 5.0,
                        borderRadius: 12.0,
                        direction: Axis
                            .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                        center: TextButton(
                          onPressed: () {
                            // Define what happens when the button is pressed
                          },
                          child: const Text(
                            "Hive 2 at 65%",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Hottest Hive',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //lets put the graph here.
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: SizedBox(
                        width: 350,
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MyBarGraph(
                            weeklySummary: weeklySummary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Honey Harvest Season',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //season progress bar here.

                  Center(
                    child: CircularPercentIndicator(
                      animation: true,
                      animationDuration: 1000,
                      radius: 130,
                      lineWidth: 30,
                      percent: 0.4,
                      progressColor: Colors.orange,
                      backgroundColor: Colors.deepOrange.shade100,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: const Text(
                        '4 months left',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.deepOrange,
                        ),
                      ),
// Text
                    ), // CircularPercentIndicator
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Most Recent Harvests',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //recent harvests card
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
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                  ),
                                  Icon(
                                    Icons.polyline,
                                    color: Color.fromARGB(255, 63, 59, 59),
                                  ),
                                  Text(
                                    'Recent Harvests',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
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
                                            'Mubende farm',
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
                                              color: Colors.grey[
                                                  300], // Background color
                                            ),
                                            child: const Text('Hives: 3'),
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
                                              color: Colors
                                                  .brown, // Background color
                                            ),
                                            child: const Text(
                                              '12kg',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'Mityana farm',
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
                                              color: Colors.grey[
                                                  300], // Background color
                                            ),
                                            child: const Text('Hives: 5'),
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
                                              color: Colors
                                                  .brown, // Background color
                                            ),
                                            child: const Text(
                                              '15kg',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'Hoima farm',
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
                                              color: Colors.grey[
                                                  300], // Background color
                                            ),
                                            child: const Text('Hives: 7'),
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
                                              color: Colors
                                                  .brown, // Background color
                                            ),
                                            child: const Text(
                                              '22kg',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'See all',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
