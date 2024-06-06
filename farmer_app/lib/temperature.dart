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
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(Duration(days: 6));
    getTempData(widget.hiveId, _startDate, _endDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null && picked.start != null && picked.end != null) {
      setState(() {
        _startDate = picked.start!;
        _endDate = picked.end!;
      });

      getTempData(widget.hiveId, _startDate, _endDate);
    }
  }

  Future<void> getTempData(int hiveId, DateTime startDate, DateTime endDate) async {
    try {
      String sendToken = "Bearer ${widget.token}";
      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };

      String formattedStartDate = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      print("Start Date: $formattedStartDate");

      String formattedEndDate = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";
      print("End Date: $formattedEndDate");

      var request = http.Request(
        'GET',
        Uri.parse('https://www.ademnea.net/api/v1/hives/$hiveId/temperature/$formattedStartDate/$formattedEndDate'),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonData = jsonDecode(responseBody);
        List<DateTime> newDates = [];
        List<double?> newInteriorTemperatures = [];
        List<double?> newExteriorTemperatures = [];
        for (var dataPoint in jsonData['data']) {
          newDates.add(DateTime.parse(dataPoint['date']));
          if (dataPoint['interiorTemperature'] != null) {
            newInteriorTemperatures.add(double.tryParse(dataPoint['interiorTemperature']));
          } else {
            newInteriorTemperatures.add(0);
          }
          if (dataPoint['exteriorTemperature'] != null) {
            newExteriorTemperatures.add(double.tryParse(dataPoint['exteriorTemperature']));
          } else {
            newExteriorTemperatures.add(0);
          }
        }

        setState(() {
          dates = newDates;
          print("Dates: $dates");
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

  double? _getLowestTemperature(List<double?> temperatures) {
    final filteredTemperatures = temperatures.where((temp) => temp != null && temp > 0).cast<double>().toList();
    if (filteredTemperatures.isNotEmpty) {
      return filteredTemperatures.reduce((a, b) => a < b ? a : b);
    }
    return null;
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
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Hive temperature',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300]),
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () async {},
                    icon: const Icon(
                      LineIcons.alternateCloudDownload,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: const Text('Download Data'),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: const Icon(
                      LineIcons.calendar,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: const Text('Choose Date'),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.5,
                child: Graphs(
                  xValues: dates,
                  yValues1: interiorTemperatures.where((temp) => temp != null).cast<double>().toList(),
                  yValues2: exteriorTemperatures.where((temp) => temp != null).cast<double>().toList(),
                  xAxisLabel: 'Time in hours',
                  yAxisLabel: 'Temperature (°C)',
                  xAxisSpacing: Duration(days: 1),
                  yAxisSpacing: 3,
                  title: 'Hive Temperature',
                  minY: 10.0,
                  maxY: 45.0,
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
                      Text('Lowest: ${_getLowestTemperature(interiorTemperatures) ?? ''} °C'),
                      Text('Exterior Temperature Stats:'),
                      Text('Highest: ${exteriorTemperatures.isNotEmpty ? exteriorTemperatures.reduce((a, b) => a! > b! ? a : b)! : ''} °C'),
                      Text('Lowest: ${_getLowestTemperature(exteriorTemperatures) ?? ''} °C'),
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
