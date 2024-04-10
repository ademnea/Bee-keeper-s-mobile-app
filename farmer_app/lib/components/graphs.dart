import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class Graphs extends StatefulWidget {
  final List<DateTime> xValues;
  final List<double?> yValues;
  final String xAxisLabel;
  final String yAxisLabel;

  const Graphs({
    Key? key,
    required this.xValues,
    required this.yValues,
    required this.xAxisLabel,
    required this.yAxisLabel,
  }) : super(key: key);

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  @override
  Widget build(BuildContext context) {
    if (widget.xValues.isEmpty || widget.yValues.isEmpty) {
      return const Center(
        child: Text('Oops! No data available.'),
      );
    }

    // Calculate the minimum non-null Y value
    double minYValue = widget.yValues
        .where((value) => value != null)
        .map<double>((value) => value!)
        .reduce((value, element) => value < element ? value : element);

    // Replace null values in yValues with the minimum non-null value
    List<double> yValuesWithMin =
        widget.yValues.map((value) => value ?? minYValue).toList();

    // Calculate minY and maxY to ensure they accommodate the adjusted yValues
    double adjustedMinY = yValuesWithMin
        .reduce((value, element) => value < element ? value : element);
    double adjustedMaxY = yValuesWithMin
        .reduce((value, element) => value > element ? value : element);

    return LineChart(
      LineChartData(
        minX: widget.xValues
            .map<double>(
                (dateTime) => dateTime.millisecondsSinceEpoch.toDouble())
            .reduce((value, element) => value < element ? value : element),
        maxX: widget.xValues
            .map<double>(
                (dateTime) => dateTime.millisecondsSinceEpoch.toDouble())
            .reduce((value, element) => value > element ? value : element),
        minY: 22.0, // Use adjustedMinY
        maxY: adjustedMaxY, // Use adjustedMaxY
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[500], // Set color for horizontal grid lines
              strokeWidth: 1,
            );
          },
          horizontalInterval:
              60000, // Set interval to 1 minute (60000 milliseconds)
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              widget.xValues.length,
              (index) => FlSpot(
                  widget.xValues[index].millisecondsSinceEpoch.toDouble(),
                  yValuesWithMin[index]), // Use the adjusted yValues
            ),
            isCurved: true,
            color: Colors.white,
            barWidth: 1,
            isStrokeCapRound: false,
            belowBarData: BarAreaData(
              show: false,
            ),
            dotData: const FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Format the timestamp as desired
                  String formattedDate = DateFormat('HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(value.toInt()));
                  return Text(formattedDate);
                },
              ),
              axisNameWidget: Text('Time')),
        ),
      ),
    );
  }
}
