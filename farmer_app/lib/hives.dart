import 'package:flutter/material.dart';
import 'package:farmer_app/hivedetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Hives extends StatefulWidget {
  final int farmId;

  const Hives({Key? key, required this.farmId}) : super(key: key);

  @override
  State<Hives> createState() => _HivesState();
}

class Hive {
  final int id;
  final String longitude;
  final String latitude;
  final int farmId;
  final String? createdAt;
  final String? updatedAt;

  Hive({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.farmId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hive.fromJson(Map<String, dynamic> json) {
    return Hive(
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      farmId: json['farm_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class _HivesState extends State<Hives> {
  List<Hive> hives = [];

  @override
  void initState() {
    super.initState();
    getHives(widget.farmId);
  }

  Future<void> getHives(int farmId) async {
    try {
      var headers = {
        'Authorization': 'Bearer 7|5gtx0HM2FVwiLHeCT4iBACSS6oBFYNNCo3C72pKa'
      };

      var url = 'https://www.ademnea.net/api/v1/farms/$farmId/hives';
      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          hives = data.map((hive) => Hive.fromJson(hive)).toList();
        });
      } else {
        print('Failed to load hives: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching hives data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await getHives(widget.farmId);
        },
        child: Container(
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
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // ListView.builder to dynamically create cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: hives.length,
                      itemBuilder: (context, index) {
                        return buildHiveCard(hives[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHiveCard(Hive hive) {
    return Center(
      child: SizedBox(
        width: 350,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.brown[300],
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Hive ${hive.id}',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                                borderRadius: BorderRadius.circular(20),
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
                                          HiveDetails(hiveId: hive.id),
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 22),
                child: Row(
                  children: [
                    Icon(
                      Icons.hexagon,
                      color: Colors.orange[700],
                    ),
                    const Text(
                      'Recent Harvests',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '12/04/24  |  12kg',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(left: 0, bottom: 22, top: 8),
              //   child: Text(
              //     'check monitor',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
