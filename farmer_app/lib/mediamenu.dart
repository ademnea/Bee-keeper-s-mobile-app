import 'package:HPGM/hivevideos.dart';
import 'package:HPGM/media.dart';
import 'package:flutter/material.dart';

class Mediamenu extends StatefulWidget {
  final int hiveId;
  final String token;
  const Mediamenu({Key? key, required this.hiveId, required this.token});
  @override
  State<Mediamenu> createState() => _MediamenuState();
}

class _MediamenuState extends State<Mediamenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Choose Hive ' + widget.hiveId.toString() + ' Media',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300]),
          ),
        ),

        //first card
        Padding(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Media(
                          hiveId: widget.hiveId,
                          token: widget.token,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Hive Images",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        //second card
        Padding(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HiveVideos(
                          hiveId: widget.hiveId,
                          token: widget.token,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Hive Videos",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
