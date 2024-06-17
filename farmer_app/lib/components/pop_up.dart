import 'package:HPGM/components/custom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

//the buildsheet for a  temp pop up modal screen

String determineMessage(double? level) {
  if (level == null) {
    return "No data available";
  } else if (level < 20) {
    return "Low: Temperature is below optimal levels.";
  } else if (level >= 20 && level <= 29) {
    return "Moderate: Temperature is within the optimal range.";
  } else {
    return "High: Temperature is above optimal levels. Supplementary feeding around the hives may be required\n\nConsider putting a trough of water or syrups around your hives. This helps the colony thrive, in such harsh temperatures.";
  }
}

//the popup widget
Widget buildTempSheet(String title, double? Levels) => SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: const TextStyle(
                fontFamily: "Sans", fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  "Level: ${Levels?.toStringAsFixed(2) ?? '--'}°C",
                  style: const TextStyle(
                      fontFamily: "Sans",
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              CustomProgressBar(
                value: Levels ?? 0.0,
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              //  "The optimal temperature is between 20 and 29. Any values below or above are critical. Above 30, supplemetary feeding around the hives may be required.",
              determineMessage(Levels),
              style: const TextStyle(
                  fontFamily: "Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );

//building the pop up for the honey levels.
String determineHoneyMessage(double? honeyPercentage) {
  if (honeyPercentage == null) {
    return "No data available";
  } else if (honeyPercentage < 20) {
    return "Low: Honey levels are very low.";
  } else if (honeyPercentage >= 20 && honeyPercentage <= 50) {
    return "Moderate: Honey levels are moderate and good.";
  } else {
    return "High: Honey levels are above moderate. You may need to harvest honey, here.";
  }
}

//the popup widget
Widget buildHoneySheet(String title, double? Levels) => SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: const TextStyle(
                  fontFamily: "Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  "Level: ${Levels?.toStringAsFixed(2) ?? '--'}%",
                  style: const TextStyle(
                      fontFamily: "Sans",
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                height: 12,
                width: 100,
                child: LiquidLinearProgressIndicator(
                  value: Levels! / 100 ?? 0,
                  valueColor: const AlwaysStoppedAnimation(Colors.amber),
                  backgroundColor: Colors.amber[100]!,
                  borderColor: Colors.brown,
                  borderWidth: 1.0,
                  borderRadius: 12.0,
                  direction: Axis.horizontal,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              //  "The optimal temperature is between 20 and 29. Any values below or above are critical. Above 30, supplemetary feeding around the hives may be required.",
              determineHoneyMessage(Levels),
              style: const TextStyle(
                  fontFamily: "Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
