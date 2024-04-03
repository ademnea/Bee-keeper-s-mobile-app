import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
        minY: widget.yValues
            .where((value) => value != null)
            .map<double>((value) => value!)
            .reduce((value, element) => value < element ? value : element),
        maxY: widget.yValues
            .where((value) => value != null)
            .map<double>((value) => value!)
            .reduce((value, element) => value > element ? value : element),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[500], // Set color for horizontal grid lines
              strokeWidth: 1,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              widget.xValues.length,
              (index) => FlSpot(
                  widget.xValues[index].millisecondsSinceEpoch.toDouble(),
                  widget.yValues[index] ?? 0.0), // Use 0.0 if value is null
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
        titlesData: FlTitlesData(),
      ),
    );
  }
}
