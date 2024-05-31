import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

import 'components/graphs.dart';

class Temperature extends StatefulWidget {
  final int hiveId;
  final String token;

  const Temperature({Key? key, required this.hiveId, required this.token}) : super(key: key);

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  List<DateTime> dates = [];
  List<double?> interiorTemperatures = [];
  List<double?> exteriorTemperatures = [];

  @override
  void initState() {
    super.initState();
    getTempData(widget.hiveId);
  }

  Future<void> getTempData(int hiveId) async {
    try {
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };

      DateTime today = DateTime.now();
      DateTime yesterday = today.subtract(Duration(days: 1));

      String startDate = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
      String endDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      var request = http.Request(
          'GET',
          Uri.parse('https://www.ademnea.net/api/v1/hives/$hiveId/temperature/$startDate/$endDate'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        //print(responseBody);
        Map<String, dynamic> jsonData = jsonDecode(responseBody);

        List<DateTime> newDates = [];
        List<double?> newInteriorTemperatures = [];
        List<double?> newExteriorTemperatures = [];

        for (var dataPoint in jsonData['data']) {
          newDates.add(DateTime.parse(dataPoint['date']));
          newInteriorTemperatures.add(double.tryParse(dataPoint['interiorTemperature']));
          newExteriorTemperatures.add(double.tryParse(dataPoint['exteriorTemperature']));
        }

        setState(() {
          dates = newDates;
          interiorTemperatures = newInteriorTemperatures;
          print("Interior: $interiorTemperatures");
          exteriorTemperatures = newExteriorTemperatures;
          print("Exterior: $exteriorTemperatures");
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error fetching temperature data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Hive temperature for the last 24 hours',
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
                      getTempData(widget.hiveId);
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
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.5,
                  child: Graphs(
                    xValues: dates,
                    yValues1: interiorTemperatures.where((temp) => temp != null).cast<double>().toList(),
                    yValues2: exteriorTemperatures.where((temp) => temp != null).cast<double>().toList(),
                    xAxisLabel: 'Time in hours',
                    yAxisLabel: 'Temperature (°C)',
                    xAxisSpacing: Duration(hours: 1),
                    yAxisSpacing: 3,
                    title: 'Hive Temperature',
                  //  yValues: interiorTemperatures.where((temp) => temp != null).cast<double>().toList(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temperature Statistics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Interior Temperature Stats:'),
                      Text('Highest: ${interiorTemperatures.isNotEmpty ? interiorTemperatures.reduce((a, b) => a! > b! ? a : b)! : ''} °C'),
                      Text('Lowest: ${interiorTemperatures.isNotEmpty ? interiorTemperatures.reduce((a, b) => a! < b! ? a : b)! : ''} °C'),
                      // You can calculate average similarly
                      Text('Exterior Temperature Stats:'),
                      Text('Highest: ${exteriorTemperatures.isNotEmpty ? exteriorTemperatures.reduce((a, b) => a! > b! ? a : b)! : ''} °C'),
                      Text('Lowest: ${exteriorTemperatures.isNotEmpty ? exteriorTemperatures.reduce((a, b) => a! < b! ? a : b)! : ''} °C'),
                      // You can calculate average similarly
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
