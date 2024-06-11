import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
class Humidity extends StatefulWidget {
  final int hiveId;
  final String token;
  const Humidity({super.key, required this.hiveId, required this.token});

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  List<DateTime> dates = [];
  List<double?> interiorHumidity = [];
  List<double?> exteriorHumidity = [];
  late DateTime _startDate;
  late DateTime _endDate;
  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(Duration(days: 2));
    getTempData(widget.hiveId, _startDate, _endDate);
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
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
      String formattedEndDate = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      var request = http.Request(
        'GET',
        Uri.parse('https://www.ademnea.net/api/v1/hives/$hiveId/humidity/$formattedStartDate/$formattedEndDate'),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonData = jsonDecode(responseBody);
        List<DateTime> newDates = [];
        List<double?> newinteriorHumidity = [];
        List<double?> newexteriorHumidity = [];
        for (var dataPoint in jsonData['data']) {
          newDates.add(DateTime.parse(dataPoint['date']));
          double? interiorTemp = dataPoint['interiorHumidity'] != null ? double.tryParse(dataPoint['interiorHumidity'].toString()) : null;
          double? exteriorTemp = dataPoint['exteriorHumidity'] != null ? double.tryParse(dataPoint['exteriorHumidity'].toString()) : null;

          // if (interiorTemp == 0) {
          //   interiorTemp = null;
          // }
          // if (exteriorTemp == 0) {
          //   exteriorTemp = null;
          // }

          newinteriorHumidity.add(interiorTemp);
          newexteriorHumidity.add(exteriorTemp);
        }
        print("Interior Humidity: $newinteriorHumidity");
        print("Exterior Humidity: $newexteriorHumidity");

        setState(() {
          dates = newDates;
          interiorHumidity = newinteriorHumidity;
          exteriorHumidity = newexteriorHumidity;
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error fetching temperature data: $error');
    }
  }
  double? _getLowestHumidity(List<double?> temperatures) {
    final filteredTemperatures = temperatures.where((temp) => temp != null && temp > 0).cast<double>().toList();
    if (filteredTemperatures.isNotEmpty) {
      return filteredTemperatures.reduce((a, b) => a < b ? a : b);
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Hive humidity',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300]),
                ),
              ),
            ///graphic wigdet
              Container(
                height: 300,
                width: screenWidth * 0.9,
                child: Echarts(
                    option: '''
    {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'cross',
          label: {
            backgroundColor: '#6a7985'
          }
        }
      },
      legend: {
        data: ['Exterior', 'Interior']
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: ${jsonEncode(dates.map((date) => date.toString()).toList())},
        axisLabel: {
          formatter: function (value) {
            var date = new Date(value);
            return date.getFullYear() + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getDate().toString().padStart(2, '0') + ' ' + date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0') + ':' + date.getSeconds().toString().padStart(2, '0');
          }
        }
      },
      yAxis: {
        type: 'value',
        min: 50,
        max: 100,
        interval: 10,
        axisLabel: {
          formatter: '{value}%'
        }
      },
      series: [
        {
          name: 'Exterior',
          type: 'line',
          data: ${jsonEncode(exteriorHumidity)},
          itemStyle: {
            color: 'blue'
          },
          connectNulls: false
        },
        {
          name: 'Interior',
          type: 'line',
          data: ${jsonEncode(interiorHumidity)},
          itemStyle: {
            color: 'green'
          },
          connectNulls: false
        }
      ]
    }
  '''
                ),
              ),

              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Humidity Statistics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Interior Humidity Stats:'),
                      Text('Highest: ${interiorHumidity.where((temp) => temp != null).isNotEmpty ? interiorHumidity.where((temp) => temp != null).reduce((a, b) => a! > b! ? a : b)! : ''} %'),
                      Text('Lowest: ${_getLowestHumidity(interiorHumidity) ?? ''} %'),
                      Text('Exterior Humidity Stats:'),
                      Text('Highest: ${exteriorHumidity.where((temp) => temp != null).isNotEmpty ? exteriorHumidity.where((temp) => temp != null).reduce((a, b) => a! > b! ? a : b)! : ''} %'),
                      Text('Lowest: ${_getLowestHumidity(exteriorHumidity) ?? ''} %'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );

  }
}
