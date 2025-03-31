import 'package:flutter/material.dart';

Widget buildHoneySheet(String title, double honeyLevel) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('$honeyLevel%'),
      ],
    ),
  );
}
