import 'package:flutter/material.dart';
import 'package:farmer_app/hivedetails.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:convert';

class Hives extends StatefulWidget {
  final int farmId;
  final String token;

  const Hives({Key? key, required this.farmId, required this.token})
      : super(key: key);

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
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Authorization': sendToken,
      };

      var url = 'https://www.ademnea.net/api/v1/farms/$farmId/hives';
      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          hives = data.map((hive) => Hive.fromJson(hive)).toList();
        });
      } else {
        // print('Failed to load hives: ${response.reasonPhrase}');
      }
    } catch (error) {
      // print('Error fetching hives data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        color: Colors.orange,
        height: 150,
        animSpeedFactor: 2,
        onRefresh: () async {
          await getHives(widget.farmId);
        },
        child: Container(
          child: ListView(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130,
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
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.chevron_left_rounded,
                                        color:
                                            Color.fromARGB(255, 206, 109, 40),
                                        size: 65,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Prototype Apiary Hives',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Sans",
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

                      // ListView.builder to dynamically create cards
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: hives.length,
                          itemBuilder: (context, index) {
                            return buildHiveCard(hives[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
              Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.hexagon,
                      color: Colors.orange[700],
                    ),
                    const Text(
                      'Hive Name: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Hive ${hive.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                        fontFamily: "Sans",
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HiveDetails(
                                hiveId: hive.id,
                                token: widget.token,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Hive Data',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Sans",
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.developer_board_rounded,
                      color: Colors.orange[700],
                    ),
                    const Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      ' Connected ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.thermostat,
                      color: Colors.orange[700],
                    ),
                    const Text(
                      'Temperature:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      ' 25°C',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.scale_rounded,
                      color: Colors.orange[700],
                    ),
                    const Text(
                      'Weight:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      ' 23Kg',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        ' Colonized', 
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Sans",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
