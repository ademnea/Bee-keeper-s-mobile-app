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

  @override
  void initState() {
    super.initState();
    getTempData();
  }

  Future<void> getTempData() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer 7|5gtx0HM2FVwiLHeCT4iBACSS6oBFYNNCo3C72pKa'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://www.ademnea.net/api/v1/hives/1/temperature/01-01-2024/12-06-2024'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonData = jsonDecode(responseBody);

        // Process data and assign to lists
        dates = List<DateTime>.from(
            jsonData['dates'].map((date) => DateTime.parse(date)));
        interiorTemperatures = List<double?>.from(
            jsonData['interiorTemperatures']
                .map((value) => double.tryParse(value?.toString() ?? '')));

        setState(() {}); // Trigger a rebuild with the new data
      } else {
        print(response.reasonPhrase);
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
