import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

class Temperature extends StatefulWidget {
  const Temperature({Key? key}) : super(key: key);

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  List<DateTime> dates = [];
  List<double> interiorTemperatures = [];
  final url = Uri.parse(
      'https://www.ademnea.net/api/v1/hives/1/temperature/2023-12-12/2024-12-12');

  @override
  void initState() {
    super.initState();
    getTempData();
  }

  Future<void> getTempData() async {
    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['dates'] != null && data['interiorTemperatures'] != null) {
        setState(() {
          dates = List<DateTime>.from(
              data['dates'].map((date) => DateTime.parse(date)));
          // Parse temperature values as double
          interiorTemperatures = List<double>.from(data['interiorTemperatures']
              .map<double>((temp) => double.parse(temp.toString()) ?? 0.0));
        });
      }
    } else {
      print('Failed with status code: ${response.statusCode}');
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

                    // child: Graphs(
                    //   xValues: dates,
                    //   yValues: interiorTemperatures,
                    //   xAxisLabel: 'Date',
                    //   yAxisLabel: 'Temperature (F)',
                    // ),

                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         const Text(
                            'Interior Temperatures:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (interiorTemperatures.isEmpty || dates.isEmpty)
                            const Text(
                              'No data available',
                              style: TextStyle(fontSize: 14),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: interiorTemperatures.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('Date: ${dates[index]}'),
                                  subtitle: Text(
                                      'Temperature: ${interiorTemperatures[index]}'),
                                );
                              },
                            ),
                        ],
                      ),
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
