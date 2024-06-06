import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class Graphs extends StatefulWidget {
  final List<DateTime> xValues;
  final String xAxisLabel;
  final String yAxisLabel;
  final Duration xAxisSpacing;
  final double yAxisSpacing;
  final List<double> yValues1;
  final List<double> yValues2;
  final String title;
  final double minY;
  final double maxY;

  const Graphs({
    Key? key,
    required this.xValues,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.xAxisSpacing,
    required this.yAxisSpacing,
    required this.yValues1,
    required this.yValues2,
    required this.title,
    required this.minY,
    required this.maxY,
  }) : super(key: key);

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  @override
  Widget build(BuildContext context) {
    if (widget.xValues.isEmpty || widget.yValues1.isEmpty || widget.yValues2.isEmpty) {
      return const Center(
        child: Text('Oops! No data available.'),
      );
    }

    final spots1 = List.generate(
      widget.xValues.length,
          (index) {
        if (widget.yValues1[index] == 0) {
          return null; // Skip plotting zero values
        }
        return FlSpot(
          widget.xValues[index].millisecondsSinceEpoch.toDouble(),
          widget.yValues1[index],
        );
      },
    ).whereType<FlSpot>().toList();

    final spots2 = List.generate(
      widget.xValues.length,
          (index) {
        if (widget.yValues2[index] == 0) {
          return null; // Skip plotting zero values
        }
        return FlSpot(
          widget.xValues[index].millisecondsSinceEpoch.toDouble(),
          widget.yValues2[index],
        );
      },
    ).whereType<FlSpot>().toList();

    return SafeArea(
      child: LineChart(
        LineChartData(
          minX: widget.xValues
              .map<double>((dateTime) => dateTime.millisecondsSinceEpoch.toDouble())
              .reduce((value, element) => value < element ? value : element),
          maxX: widget.xValues
              .map<double>((dateTime) => dateTime.millisecondsSinceEpoch.toDouble())
              .reduce((value, element) => value > element ? value : element),
          minY: widget.minY,
          maxY: widget.maxY,
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[500], // Set color for horizontal grid lines
                strokeWidth: 1,
              );
            },
            horizontalInterval: widget.yAxisSpacing.toDouble(),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots1,
              isCurved: true,
              color: Colors.blue,
              barWidth: 1,
              isStrokeCapRound: false,
              belowBarData: BarAreaData(
                show: false,
              ),
              dotData: const FlDotData(show: true),
              preventCurveOverShooting: true,
              show: true,
              isStepLineChart: false,
            ),
            LineChartBarData(
              spots: spots2,
              isCurved: true,
              color: Colors.white,
              barWidth: 1,
              isStrokeCapRound: false,
              belowBarData: BarAreaData(
                show: false,
              ),
              dotData: const FlDotData(show: true),
              preventCurveOverShooting: true,
              show: true,
              isStepLineChart: false,
            ),
          ],
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: const SideTitles(showTitles: false),
              axisNameWidget: Text(widget.title),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
                  return RotatedBox(
                    quarterTurns: 1,
                    child: Text(formattedDate),
                  );
                },
              ),
              axisNameWidget: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(widget.xAxisLabel),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
              axisNameWidget: Text(widget.yAxisLabel),
            ),
          ),
        ),
      ),
    );
  }
}
