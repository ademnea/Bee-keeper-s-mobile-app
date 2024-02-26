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
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 1),
                const FlSpot(1, 3),
                const FlSpot(2, 2),
                const FlSpot(3, 4),
                const FlSpot(4, 3),
                const FlSpot(5, 5),
              ],
              isCurved: true,
              //colors: [Colors.blue],
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              dotData: const FlDotData(show: false),
            ),
          ],
          titlesData: const FlTitlesData(
              // bottomTitles: SideTitles(showTitles: false),
              // leftTitles: SideTitles(showTitles: false),
              ),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}
