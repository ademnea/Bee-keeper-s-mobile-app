import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';

class Humidity extends StatefulWidget {
  final int hiveId;
  final String token;

  const Humidity({Key? key, required this.hiveId, required this.token})
      : super(key: key);

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  List<DateTime> dates = [];
  List<double?> interiorHumidity = [];
  List<double?> exteriorHumidity = [];
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 7));
    _getHumidityData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.amber,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _isLoading = true;
        _errorMessage = null;
      });
      await _getHumidityData();
    }
  }

  Future<void> _getHumidityData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://196.43.168.57/api/v1/hives/${widget.hiveId}/humidity/'
          '${DateFormat('yyyy-MM-dd').format(_startDate)}/'
          '${DateFormat('yyyy-MM-dd').format(_endDate)}',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final newDates = <DateTime>[];
        final newInteriorHumidity = <double?>[];
        final newExteriorHumidity = <double?>[];

        for (final dataPoint in jsonData['data']) {
          newDates.add(DateTime.parse(dataPoint['date']));

          final interiorHum = dataPoint['interiorHumidity'] != null
              ? double.tryParse(dataPoint['interiorHumidity'].toString())
              : null;
          final exteriorHum = dataPoint['exteriorHumidity'] != null
              ? double.tryParse(dataPoint['exteriorHumidity'].toString())
              : null;

          newInteriorHumidity.add(interiorHum == 0 ? null : interiorHum);
          newExteriorHumidity.add(exteriorHum == 0 ? null : exteriorHum);
        }

        setState(() {
          dates = newDates;
          interiorHumidity = newInteriorHumidity;
          exteriorHumidity = newExteriorHumidity;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data: ${response.reasonPhrase}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error fetching humidity data: $error';
        _isLoading = false;
      });
    }
  }

  double? _getHighestHumidity(List<double?> humidity) {
    final validHumidity = humidity.whereType<double>().toList();
    return validHumidity.isNotEmpty
        ? validHumidity.reduce((a, b) => a > b ? a : b)
        : null;
  }

  double? _getLowestHumidity(List<double?> humidity) {
    final validHumidity = humidity.whereType<double>().toList();
    return validHumidity.isNotEmpty
        ? validHumidity.reduce((a, b) => a < b ? a : b)
        : null;
  }

  double? _getAverageHumidity(List<double?> humidity) {
    final validHumidity = humidity.whereType<double>().toList();
    return validHumidity.isNotEmpty
        ? validHumidity.reduce((a, b) => a + b) / validHumidity.length
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final chartTextColor = isDarkMode ? 'white' : '#333';

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Hive ${widget.hiveId} Humidity',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.amber[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('MMM d, y').format(_startDate)} - '
                      '${DateFormat('MMM d, y').format(_endDate)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          context,
                          icon: LineIcons.calendar,
                          label: 'Change Date',
                          onPressed: () => _selectDate(context),
                        ),
                        _buildActionButton(
                          context,
                          icon: LineIcons.alternateCloudDownload,
                          label: 'Export Data',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Chart Container
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Humidity Trend',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (dates.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: Center(
                          child: Text(
                            'No humidity data available',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 300,
                        child: Echarts(
                          option: '''
                          {
                            backgroundColor: 'transparent',
                            tooltip: {
                              trigger: 'axis',
                              axisPointer: { 
                                type: 'cross',
                                label: {
                                  backgroundColor: '#6a7985'
                                }
                              },
                              formatter: function(params) {
                                let result = '<div style="font-weight:bold;margin-bottom:5px;">' + 
                                  params[0].axisValueLabel + '</div>';
                                params.forEach((item) {
                                  result += '<div>' + item.marker + ' ' + item.seriesName + 
                                    ': <span style="font-weight:bold;color:' + item.color + '">' + 
                                    item.value + '%</span></div>';
                                });
                                return result;
                              }
                            },
                            legend: {
                              data: ['Exterior', 'Interior'],
                              textStyle: { 
                                color: '$chartTextColor',
                                fontSize: 14
                              },
                              itemGap: 20,
                              right: 10,
                              top: 10
                            },
                            grid: { 
                              left: '3%',
                              right: '4%',
                              bottom: '3%',
                              containLabel: true 
                            },
                            xAxis: {
                              type: 'category',
                              boundaryGap: false,
                              data: ${jsonEncode(dates.map((d) => DateFormat('MMM d').format(d)))},
                              axisLine: {
                                lineStyle: {
                                  color: '${isDarkMode ? 'rgba(255,255,255,0.3)' : 'rgba(0,0,0,0.3)'}'
                                }
                              },
                              axisLabel: { 
                                color: '$chartTextColor',
                                fontSize: 12,
                                rotate: 30
                              }
                            },
                            yAxis: {
                              type: 'value',
                              min: 30,
                              max: 90,
                              interval: 15,
                              axisLine: {
                                lineStyle: {
                                  color: '${isDarkMode ? 'rgba(255,255,255,0.3)' : 'rgba(0,0,0,0.3)'}'
                                }
                              },
                              axisLabel: { 
                                formatter: '{value}%',
                                color: '$chartTextColor',
                                fontSize: 12
                              },
                              splitLine: {
                                lineStyle: {
                                  color: '${isDarkMode ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.1)'}'
                                }
                              }
                            },
                            series: [
                              {
                                name: 'Exterior',
                                type: 'line',
                                smooth: true,
                                symbol: 'circle',
                                symbolSize: 6,
                                data: ${jsonEncode(exteriorHumidity)},
                                itemStyle: { 
                                  color: '#4285F4',
                                  borderColor: '#fff',
                                  borderWidth: 1
                                },
                                lineStyle: { 
                                  width: 3,
                                  color: '#4285F4'
                                },
                                areaStyle: {
                                  color: {
                                    type: 'linear',
                                    x: 0,
                                    y: 0,
                                    x2: 0,
                                    y2: 1,
                                    colorStops: [{
                                      offset: 0,
                                      color: 'rgba(66, 133, 244, 0.3)'
                                    }, {
                                      offset: 1,
                                      color: 'rgba(66, 133, 244, 0.1)'
                                    }]
                                  }
                                },
                                markPoint: {
                                  data: [
                                    { type: 'max', name: 'Max' },
                                    { type: 'min', name: 'Min' }
                                  ],
                                  symbolSize: 50,
                                  label: {
                                    color: 'white',
                                    formatter: '{b}: {c}%'
                                  }
                                },
                                markLine: {
                                  data: [{ type: 'average', name: 'Avg' }],
                                  label: {
                                    color: 'white',
                                    formatter: 'Avg: {c}%'
                                  }
                                }
                              },
                              {
                                name: 'Interior',
                                type: 'line',
                                smooth: true,
                                symbol: 'circle',
                                symbolSize: 6,
                                data: ${jsonEncode(interiorHumidity)},
                                itemStyle: { 
                                  color: '#0F9D58',
                                  borderColor: '#fff',
                                  borderWidth: 1
                                },
                                lineStyle: { 
                                  width: 3,
                                  color: '#0F9D58'
                                },
                                areaStyle: {
                                  color: {
                                    type: 'linear',
                                    x: 0,
                                    y: 0,
                                    x2: 0,
                                    y2: 1,
                                    colorStops: [{
                                      offset: 0,
                                      color: 'rgba(15, 157, 88, 0.3)'
                                    }, {
                                      offset: 1,
                                      color: 'rgba(15, 157, 88, 0.1)'
                                    }]
                                  }
                                },
                                markPoint: {
                                  data: [
                                    { type: 'max', name: 'Max' },
                                    { type: 'min', name: 'Min' }
                                  ],
                                  symbolSize: 50,
                                  label: {
                                    color: 'white',
                                    formatter: '{b}: {c}%'
                                  }
                                },
                                markLine: {
                                  data: [{ type: 'average', name: 'Avg' }],
                                  label: {
                                    color: 'white',
                                    formatter: 'Avg: {c}%'
                                  }
                                }
                              }
                            ]
                          }
                          ''',
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    context,
                    title: 'Interior',
                    icon: Icons.home,
                    color: Colors.green,
                    high: _getHighestHumidity(interiorHumidity),
                    low: _getLowestHumidity(interiorHumidity),
                    avg: _getAverageHumidity(interiorHumidity),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatsCard(
                    context,
                    title: 'Exterior',
                    icon: Icons.cloud,
                    color: Colors.blue,
                    high: _getHighestHumidity(exteriorHumidity),
                    low: _getLowestHumidity(exteriorHumidity),
                    avg: _getAverageHumidity(exteriorHumidity),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Additional Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Humidity Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      icon: Icons.info_outline,
                      text: 'Ideal hive humidity: 40-60%',
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.warning_amber_rounded,
                      text: 'Below 30% or above 80% may harm bees',
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.water_drop,
                      text: 'Humidity affects honey quality and bee health',
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

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isDarkMode ? Colors.white : Colors.amber[800],
        backgroundColor: isDarkMode ? Colors.grey[700] : Colors.amber[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required double? high,
    required double? low,
    required double? avg,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatItem(
              context,
              label: 'Highest',
              value: high,
              unit: '%',
              icon: Icons.arrow_upward,
              color: color,
            ),
            _buildStatItem(
              context,
              label: 'Lowest',
              value: low,
              unit: '%',
              icon: Icons.arrow_downward,
              color: color,
            ),
            _buildStatItem(
              context,
              label: 'Average',
              value: avg,
              unit: '%',
              icon: Icons.show_chart,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required double? value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            value != null ? '${value.toStringAsFixed(1)}$unit' : '--',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
