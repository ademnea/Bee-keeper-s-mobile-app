import 'package:flutter/material.dart';

class NotificationComponent extends StatelessWidget {
  final String date;
  final String title;
  final String content;

  const NotificationComponent({
    Key? key,
    required this.date,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey[400], // Grey and transparent background
          borderRadius: BorderRadius.circular(15.0), // Rounded edges
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontFamily: "Sans",
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "Sans",
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: const TextStyle(
                fontFamily: "Sans",
                color: Colors.black87,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
