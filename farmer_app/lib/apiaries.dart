import 'dart:convert';
import 'package:HPGM/components/pop_up.dart';
import 'package:HPGM/hives.dart';
import 'package:HPGM/components/custom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class Apiaries extends StatefulWidget {
  final String token;

  const Apiaries({Key? key, required this.token}) : super(key: key);

  @override
  State<Apiaries> createState() => _ApiariesState();
}

class Farm {
  final int id;
  final int ownerId;
  final String name;
  final String district;
  final String address;
  final double? average_temperature;
  final double? average_weight;
  final double? honeypercent;
  final String? createdAt;
  final String? updatedAt;

  Farm({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.district,
    required this.average_temperature,
    required this.average_weight,
    required this.honeypercent,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      ownerId: json['ownerId'],
      name: json['name'],
      district: json['district'],
      address: json['address'],
      average_temperature: json['average_temperature']?.toDouble(),
      average_weight: json['average_weight']?.toDouble(),
      honeypercent: json['average_honey_percentage']?.toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class _ApiariesState extends State<Apiaries> {
  List<Farm> farms = [];

  @override
  void initState() {
    super.initState();
    getApiaries();
  }

  Future<void> getApiaries() async {
    try {
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var response = await http.get(
        Uri.parse('https://www.ademnea.net/api/v1/farms/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          farms = data.map((farm) => Farm.fromJson(farm)).toList();
        });
      } else {
        //  print('Failed to load farms: ${response.reasonPhrase}');
      }
    } catch (error) {
      //  print('Error fetching Apiary data: $error');
    }
  }

  Future<void> _handleRefresh() async {
    //reload the page data.
    // initState();
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange[100],
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Colors.orange,
        height: 150,
        animSpeedFactor: 2,
        showChildOpacityTransition: true,
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 125,
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
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    'lib/images/log-1.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                const Text(
                                  'Apiaries',
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

                    // ListView.builder to dynamically create cards

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: farms.length,
                      itemBuilder: (context, index) {
                        return buildFarmCard(farms[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFarmCard(Farm farm) {
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
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Apiary:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: "Sans"),
                              ),
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
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                farm.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                    fontFamily: "Sans",
                                    color: Colors.white),
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
                              // Navigate to hives page by sending the hive id

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Hives(
                                      farmId: farm.id, token: widget.token),
                                ),
                              );
                            },
                            child: const Text(
                              'view hives',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: "Sans",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.orange[700],
                    ),
                    const Text(
                      'Location:',
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
                      '${farm.district}, ${farm.address}',
                      style: const TextStyle(
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
                child: InkWell(
                  // on tap, we display the pop up.
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => buildTempSheet(
                      "Temperature Details",
                      farm.average_temperature ?? 0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.thermostat,
                        color: Colors.orange[700],
                      ),
                      const Text(
                        'Average Temperature:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Sans",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomProgressBar(
                        value: farm.average_temperature ?? 0,
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
                    farm.honeypercent ?? 0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 22, bottom: 20),
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
                          value: (farm.honeypercent ?? 0) / 100,
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
            ],
          ),
        ),
      ),
    );
  }
}
