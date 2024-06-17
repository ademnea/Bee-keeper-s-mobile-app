import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;

  const CustomProgressBar({
    Key? key,
    required this.value,
  }) : super(key: key);

  Color getFillColor(double myvalue) {
    if (value >= 20 && myvalue <= 29) {
      return Colors.green; // Shade of green for values between 20% and 29%
    } else {
      return Colors.red; // Red for values outside the 20%-29% range
    }
  }

  double getValue(double temperature) {
    if (temperature <= 15) {
      return 0.15;
    } else if (temperature > 15 && temperature <= 29) {
      return 0.64;
    } else if (temperature > 29 && temperature <= 35) {
      return 0.74;
    } else {
      return 0.85;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      width: 100,
      child: LiquidLinearProgressIndicator(
        value: getValue(value),
        valueColor: AlwaysStoppedAnimation(getFillColor(value)),
        backgroundColor: Colors.amber[100]!,
        borderColor: Colors.brown,
        borderWidth: 1.0,
        borderRadius: 12.0,
        direction: Axis.horizontal,
      ),
    );
  }
}
