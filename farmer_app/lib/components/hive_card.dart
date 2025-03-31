import 'package:flutter/material.dart';
import 'package:HPGM/hivedetails.dart';
import 'package:HPGM/components/custom_progress_bar.dart';
import 'package:HPGM/components/pop_up.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:HPGM/records_form.dart';

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
}

class HiveCard extends StatelessWidget {
  final Hive hive;
  final String token;
  final String apiaryLocation;
  final String farmName;

  const HiveCard({
    Key? key,
    required this.hive,
    required this.token,
    required this.apiaryLocation,
    required this.farmName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 5),
                child: Row(
                  children: [
                    Icon(Icons.hexagon, color: Colors.orange[700]),
                    const Text(
                      'Hive Name: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Hive ${hive.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                        fontFamily: "Sans",
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HiveDetails(
                              hiveId: hive.id,
                              token: token,
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
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.developer_board_rounded,
                        color: Colors.orange[700]),
                    const Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Sans",
                      ),
                    ),
                    const SizedBox(width: 10),
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
                      Icon(Icons.thermostat, color: Colors.orange[700]),
                      const Text(
                        'Temperature:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Sans",
                        ),
                      ),
                      const SizedBox(width: 10),
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
                      Icon(Icons.scale_rounded, color: Colors.orange[700]),
                      const Text(
                        'Honey Levels:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Sans",
                        ),
                      ),
                      const SizedBox(width: 10),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordsForm(
                          apiaryLocation: apiaryLocation,
                          hiveId: 'Hive ${hive.id}',
                          farmName: farmName,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Inspect Hive',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
