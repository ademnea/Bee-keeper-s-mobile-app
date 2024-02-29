import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graphs extends StatefulWidget {
  const Graphs({super.key});

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 6,
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
            spots: [
              const FlSpot(0, 0),
              const FlSpot(1, 3),
              const FlSpot(2, 2),
              const FlSpot(3, 4),
              const FlSpot(4, 3),
              const FlSpot(5, 5),
            ],
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
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            axisNameWidget: Text('Temperature (F)'),
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text('Date'),
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
      ),
    );
  }
}
