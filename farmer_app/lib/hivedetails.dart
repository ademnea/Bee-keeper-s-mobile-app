import 'package:HPGM/components/imageslider.dart';
import 'package:HPGM/parameter_tab_view.dart';
import 'package:HPGM/components/notificationbar.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // for date formatting

class HiveDetails extends StatefulWidget {
  final int hiveId;
  final double? honeyLevel;
  final String token;

  const HiveDetails({
    Key? key,
    required this.hiveId,
    required this.token,
    required this.honeyLevel,
  }) : super(key: key);

  @override
  State<HiveDetails> createState() => _HiveDetailsState();
}

class _HiveDetailsState extends State<HiveDetails> {
  List<String> photos = [];
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // For presentation purposes
    DateTime startDate = DateTime(2024, 5, 21);
    DateTime endDate = DateTime(2024, 6, 5);
    fetchPhotos(widget.hiveId, startDate, endDate);
  }

  Future<void> fetchPhotos(int hiveId, DateTime startDate, DateTime endDate) async {
    try {
      String sendToken = "Bearer ${widget.token}";
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };

      var response = await http.get(
        Uri.parse(
            'http://196.43.168.57/api/v1/hives/$hiveId/images/$formattedStartDate/$formattedEndDate'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        String responseBody = response.body;
        final jsonData = jsonDecode(responseBody);

        List<dynamic> imagePaths = jsonData['data'];

        setState(() {
          photos = imagePaths
              .map<String>((item) =>
                  'http://196.43.168.57/${item['path'].replaceFirst("public/", "")}')
              .toList();
        });
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (error) {
      print('Error fetching photos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.amber[800]!,
                    Colors.amber[600]!,
                    Colors.amber[400]!,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Hive ${widget.hiveId} Details',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Image Slider Section
            if (photos.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ImageSlider(
                    imageUrls: photos,
                  ),
                ),
              ),
            
            const SizedBox(height: 25),
            
            // Main Content Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Device Status Section
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.developer_board,
                              color: Colors.amber[800],
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Device Status:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Connected',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            
                            
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TabView(
                                  hiveId: widget.hiveId,
                                  token: widget.token,
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.amber[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Monitor',
                            style: TextStyle(
                              color: Colors.amber[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1, thickness: 1, indent: 15, endIndent: 15),
                  
                  // Honey Level Section
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.hive,
                              color: Colors.amber[800],
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Honey Levels',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Container(
                            height: 250,
                            width: 150,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: LiquidLinearProgressIndicator(
                              value: (widget.honeyLevel ?? 0) / 100,
                              valueColor: AlwaysStoppedAnimation(Colors.amber[700]!),
                              backgroundColor: Colors.amber[100]!,
                              borderColor: Colors.amber[800]!,
                              borderWidth: 3.0,
                              borderRadius: 12.0,
                              direction: Axis.vertical,
                              center: Text(
                                "${widget.honeyLevel != null ? widget.honeyLevel!.toStringAsFixed(1) : '--'}%",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            widget.honeyLevel != null && widget.honeyLevel! > 75
                                ? "Hive is almost full!"
                                : widget.honeyLevel != null && widget.honeyLevel! > 50
                                    ? "Good honey production"
                                    : widget.honeyLevel != null && widget.honeyLevel! > 25
                                        ? "Moderate honey levels"
                                        : "Low honey levels",
                            style: TextStyle(
                              color: Colors.amber[800],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1, thickness: 1, indent: 15, endIndent: 15),
                  
                  // Notifications Section
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications,
                              color: Colors.amber[800],
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Hive Notifications',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const NotificationComponent(
                          date: 'June 3, 2024',
                          title: 'Normal Condition',
                          content: 'All looks good with this hive.',
                        ),
                        const SizedBox(height: 10),
                        const NotificationComponent(
                          date: 'May 28, 2024',
                          title: 'Temperature Alert',
                          content: 'High temperature detected in the hive.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}