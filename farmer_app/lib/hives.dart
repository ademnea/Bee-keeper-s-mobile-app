import 'package:flutter/material.dart';
import 'package:HPGM/hivedetails.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:HPGM/components/custom_progress_bar.dart';
import 'package:HPGM/components/pop_up.dart';
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
  final double? weight;
  final double? honeyLevel;
  final double? temperature;
  final bool isConnected;
  final bool isColonized;

  Hive({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.farmId,
    required this.createdAt,
    required this.updatedAt,
    required this.weight,
    required this.temperature,
    required this.honeyLevel,
    required this.isConnected,
    required this.isColonized,
  });

  factory Hive.fromJson(Map<String, dynamic> json) {
    return Hive(
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      farmId: json['farm_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      weight: json['state']['weight']['record']?.toDouble(),
      temperature:
          json['state']['temperature']['interior_temperature']?.toDouble(),
      honeyLevel: json['state']['weight']['honey_percentage']?.toDouble(),
      isConnected: json['state']['connection_status']['Connected'],
      isColonized: json['state']['colonization_status']['Colonized'],
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

        // print(data);

        setState(() {
          hives = data.map((hive) => Hive.fromJson(hive)).toList();

          //print(hives);
        });
      } else {
        // Show an error message or handle the error appropriately
        print('Failed to load hive data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error fetching hives: $error');
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
                                honeyLevel: hive.honeyLevel,
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
                    Text(
                      hive.isConnected ? 'Connected' : 'Disconnected',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: hive.isConnected ? Colors.white : Colors.red,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => buildTempSheet(
                    "Temperature Details",
                    hive.temperature ?? 0,
                  ),
                ),
                child: Padding(
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

                      //temp levels indicator
                      CustomProgressBar(
                        value: hive.temperature ?? 0,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => buildHoneySheet(
                    "Honey Levels",
                    hive.honeyLevel ?? 0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 22, bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.scale_rounded,
                        color: Colors.orange[700],
                      ),
                      const Text(
                        'Honey Levels:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Sans",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 12,
                        width: 100,
                        child: LiquidLinearProgressIndicator(
                          value: (hive.honeyLevel ?? 0) / 100,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.amber),
                          backgroundColor: Colors.amber[100]!,
                          borderColor: Colors.brown,
                          borderWidth: 1.0,
                          borderRadius: 12.0,
                          direction: Axis.horizontal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  hive.isColonized ? 'Colonized' : 'Not Colonized',
                  style: const TextStyle(
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
      ),
    );
  }
}
