import 'package:HPGM/components/custom_progress_bar.dart';
import 'package:HPGM/components/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'farm_model.dart';
import 'hives.dart'; // Assuming Hives is in a separate file

Widget buildFarmCard(Farm farm, BuildContext context, String token) {
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Hives(farmId: farm.id, token: token),
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
                        valueColor: const AlwaysStoppedAnimation(Colors.amber),
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