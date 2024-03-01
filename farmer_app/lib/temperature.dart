import 'package:farmer_app/components/graphs.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Temperature Vs Time',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[300]),
                  ),
                ),

                Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          LineIcons.alternateCloudDownload,
                          color: Colors.white,
                          size: 30,
                        ),
                        label: const Text('')),
                    const Spacer(),
                    TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          LineIcons.calendar,
                          color: Colors.white,
                          size: 30,
                        ),
                        label: const Text('Choose Date')),
                  ],
                ), // end of buttons row.
                //start of the graph
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: const SizedBox(
                    width: double.infinity, // Adjust width as needed
                    height: 550, // Adjust height as needed
                    child: Graphs(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
