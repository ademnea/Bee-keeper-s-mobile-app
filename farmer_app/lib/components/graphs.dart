import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class Graphs extends StatefulWidget {
  final List<DateTime> xValues;
//  final List<double?> yValues;
  final String xAxisLabel;
  final String yAxisLabel;
  final Duration xAxisSpacing;
  final int yAxisSpacing;
  final List<double> yValues1;
  final List<double> yValues2;
  final String title;
  //final Color colory1;
  //final Color colory2;

  const Graphs({
    Key? key,
    required this.xValues,
    //required this.yValues,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.xAxisSpacing,
    required this.yAxisSpacing,
    required this.yValues1,
    required this.yValues2,
    required this.title,
  }) : super(key: key);

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  @override
  Widget build(BuildContext context) {
    // if (widget.xValues.isEmpty || widget.yValues.isEmpty) {
    //   return const Center(
    //     child: Text('Oops! No data available.'),
    //   );
    // }

    // Calculate the minimum non-null Y value
    // double minYValue = widget.yValues
    //     .where((value) => value != null)
    //     .map<double>((value) => value!)
    //     .reduce((value, element) => value < element ? value : element);

    // Replace null values in yValues with the minimum non-null value
    // List<double> yValuesWithMin =
    // widget.yValues.map((value) => value ?? minYValue).toList();

    // Calculate minY and maxY to ensure they accommodate the adjusted yValues
    // double adjustedMinY = yValuesWithMin
    //     .reduce((value, element) => value < element ? value : element);
    // double adjustedMaxY = yValuesWithMin
    //     .reduce((value, element) => value > element ? value : element);

    return SafeArea(
      child: LineChart(
        LineChartData(
          minX: widget.xValues
              .map<double>(
                  (dateTime) => dateTime.millisecondsSinceEpoch.toDouble())
              .reduce((value, element) => value < element ? value : element),
          maxX: widget.xValues
              .map<double>(
                  (dateTime) => dateTime.millisecondsSinceEpoch.toDouble())
              .reduce((value, element) => value > element ? value : element),
          minY: 20,
          maxY: 30,
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[500], // Set color for horizontal grid lines
                strokeWidth: 1,
              );
            },
            horizontalInterval:
            widget.yAxisSpacing.toDouble(), // Set interval to yAxisSpacing
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                widget.xValues.length,
                    (index) => FlSpot(
                  widget.xValues[index].millisecondsSinceEpoch.toDouble(),
                  widget.yValues1[index], // Use yValues1 for this line
                ),
              ),
              isCurved: true,
              color: Colors.blue, // Set color for the first line
              barWidth: 1,
              isStrokeCapRound: false,
              belowBarData: BarAreaData(
                show: false,
              ),
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              spots: List.generate(
                widget.xValues.length,
                    (index) => FlSpot(
                  widget.xValues[index].millisecondsSinceEpoch.toDouble(),
                  widget.yValues2[index], // Use yValues2 for this line
                ),
              ),
              isCurved: true,
              color: Colors.white, // Set color for the second line
              barWidth: 1,
              isStrokeCapRound: false,
              belowBarData: BarAreaData(
                show: false,
              ),
              dotData: const FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
                sideTitles: const SideTitles(
                    showTitles: false,
                ),
              axisNameWidget: Text(widget.title)
      
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      
      
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    String formattedDate = DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(value.toInt()));
                    return Text(formattedDate);
                  },
                ),
                axisNameWidget: Text(widget.xAxisLabel)),
      
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget:
                 (value, meta) {
                    return Text(value.toInt().toString());}
                ),
                axisNameWidget: Text(widget.yAxisLabel)),
          ),
        ),
      ),
    );
  }
}
