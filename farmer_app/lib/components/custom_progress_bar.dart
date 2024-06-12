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
    if (value >= 20 && myvalue <= 28) {
      return Colors.green; // Shade of green for values between 20% and 29%
    } else {
      return Colors.red; // Red for values outside the 20%-29% range
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      width: 100,
      child: LiquidLinearProgressIndicator(
        value: 0.64,
        //value: homeData?.averageHoneyPercentage ?? 0,
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
