import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:farmer_app/components/graphs.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

class Temperature extends StatefulWidget {
  const Temperature({Key? key}) : super(key: key);

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  List<DateTime> dates = [];
  List<double?> interiorTemperatures = []; // Nullable double
  final url = Uri.parse(
      'https://www.ademnea.net/api/v1/hives/1/temperature/2023-12-12/2024-12-12');

  @override
  void initState() {
    super.initState();
    getTempData();
  }

  Future<void> getTempData() async {
    try {
      final response = await http.get(url);

      // print(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['dates'] != null &&
            jsonData['interiorTemperatures'] != null) {
          final List<String> dateStrings = List<String>.from(jsonData['dates']);
          final List<dynamic> temperatureValues =
              List<dynamic>.from(jsonData['interiorTemperatures']);

          setState(() {
            dates = dateStrings.map<DateTime>((dateString) {
              return DateTime.parse(dateString);
            }).toList();

            interiorTemperatures = temperatureValues
                .map<double?>((tempValue) => tempValue != null
                    ? double.tryParse(tempValue.toString())
                    : null)
                .toList();
          });
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching temperature data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Temperature Vs Time',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[300]),
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        getTempData();
                      },
                      icon: const Icon(
                        LineIcons.alternateCloudDownload,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const Text(''),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        LineIcons.calendar,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const Text('Choose Date'),
                    ),
                  ],
                ), // end of buttons row.
                //start of the graph
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity, // Adjust width as needed
                    height: 550, // Adjust height as needed

                    child: Graphs(
                      xValues: dates,
                      yValues: interiorTemperatures,
                      xAxisLabel: 'Date',
                      yAxisLabel: 'Temperature (F)',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
