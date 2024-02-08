import 'package:farmer_app/splashscreen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    height: 10,
                  ),
                  //image starts here
                  Container(
                    //color: Colors.white,
                    child: Center(
                      child: Image.asset(
                        'lib/images/log-1.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                  ),

                  const Text(
                    'FARM 1',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 10,
                  ),
                  //row with the farm info

                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 0), // Add left padding to the prefix icon
                          child: Icon(
                            Icons.location_on,
                            color: Color.fromARGB(255, 206, 109, 40),
                          ), // Placeholder icon
                        ),
                        Text(
                          "Location: Mbarara",
                        ),
                        SizedBox(width: 70),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 0), // Add left padding to the prefix icon
                          child: Icon(
                            Icons.bungalow_outlined,
                            color: Color.fromARGB(255, 206, 109, 40),
                          ), // Placeholder icon
                        ), // Add some space between the texts
                        Text(
                          "Hives: 5",
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 20,
                  ),

                  //first card
                  Center(
                    child: SizedBox(
                      //height: 200,
                      width: 350,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bug_report,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Hive #2'),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Text('Table'),
                                ],
                              ),
                            ),
                            Table(
                              //border: TableBorder.all(), // Add border around the table
                              children: const [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Attribute')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Brood')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Honey')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Exterior')),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Temp')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Humidity')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('50')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('60')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('60')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.balance,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Weight: 80kg'),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Icon(
                                    Icons.air,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Carbondioxide: 30ppm'),
                                ],
                              ),
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
                                child: const Text('View Hive')),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 20,
                  ),
                  //second card
                  Center(
                    child: SizedBox(
                      //height: 200,
                      width: 350,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bug_report,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Hive #2'),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Text('Table'),
                                ],
                              ),
                            ),
                            Table(
                              //border: TableBorder.all(), // Add border around the table
                              children: const [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Attribute')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Brood')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Honey')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Exterior')),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Temp')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Humidity')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('50')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('60')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('60')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.balance,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Weight: 80kg'),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Icon(
                                    Icons.air,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Carbondioxide: 30ppm'),
                                ],
                              ),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: const Text('View Hive')),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 20,
                  ),
                  //third card
                  Center(
                    child: SizedBox(
                      //height: 200,
                      width: 350,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bug_report,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Hive #2'),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Text('Table'),
                                ],
                              ),
                            ),
                            Table(
                              //border: TableBorder.all(), // Add border around the table
                              children: const [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Attribute')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Brood')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Honey')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('Exterior')),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Temp')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('40')),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(child: Text('Humidity')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('50')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('60')),
                                    ),
                                    TableCell(
                                      child: Center(child: Text('60')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.balance,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Weight: 80kg'),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Icon(
                                    Icons.air,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                  ),
                                  Text('Carbondioxide: 30ppm'),
                                ],
                              ),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: const Text('View Hive')),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 20,
                  ),
                  //bottom navigation.

                  //closes the column
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
