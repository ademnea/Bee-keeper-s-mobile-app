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
    // _endDate = DateTime.now();
    // _startDate = _endDate.subtract(Duration(days: 6));
    // fetchPhotos(widget.hiveId, _startDate, _endDate);

    //hard coded for presentation purposes
    DateTime startDate = DateTime(2024, 5, 21);
    DateTime endDate = DateTime(2024, 6, 5);
    fetchPhotos(widget.hiveId, startDate, endDate);
  }

  Future<void> fetchPhotos(
      int hiveId, DateTime startDate, DateTime endDate) async {
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
            'https://www.ademnea.net/api/v1/hives/$hiveId/images/$formattedStartDate/$formattedEndDate'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        String responseBody = response.body;
        final jsonData = jsonDecode(responseBody);

        List<dynamic> imagePaths = jsonData['data'];

        setState(() {
          photos = imagePaths
              .map<String>((item) =>
                  'https://www.ademnea.net/${item['path'].replaceFirst("public/", "")}')
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
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    width: 2000,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.orange.withOpacity(0.8),
                                Colors.orange.withOpacity(0.6),
                                Colors.orange.withOpacity(0.4),
                                Colors.orange.withOpacity(0.2),
                                Colors.orange.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Row(
                            children: [
                              Container(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.chevron_left_rounded,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                    size: 65,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 90,
                              ),
                              Text(
                                'Hive ${widget.hiveId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Sans",
                                  fontSize: 20,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 206, 109, 40),
                                size: 65,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (photos.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ImageSlider(
                        imageUrls: photos,
                      ),
                    ),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: Colors.brown[300],
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.developer_board_outlined,
                                    color: Colors.orange[700],
                                  ),
                                ),
                                const Text(
                                  'Device:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Sans",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Connected',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: "Sans",
                                  ),
                                ),
                                const Spacer(),
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
                                  child: Text(
                                    'Check Monitor',
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      fontFamily: "Sans",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey[350],
                              thickness: 2,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Honey Levels',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sans",
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: SizedBox(
                                height: 250,
                                width: 300,
                                child: LiquidLinearProgressIndicator(
                                  value: (widget.honeyLevel ?? 0) / 100,
                                  valueColor: const AlwaysStoppedAnimation(
                                      Colors.amber),
                                  backgroundColor: Colors.amber[100]!,
                                  borderColor:
                                      const Color.fromARGB(255, 8, 7, 6),
                                  borderWidth: 5.0,
                                  borderRadius: 12.0,
                                  direction: Axis.vertical,
                                  center: TextButton(
                                    onPressed: () {
                                      // Define what happens when the button is pressed
                                    },
                                    child: Text(
                                      "${widget.honeyLevel != null ? widget.honeyLevel!.toStringAsFixed(1) : '--'}%",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: "Sans",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Hive Notifications',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sans",
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: const Column(
                                children: [
                                  NotificationComponent(
                                    date: 'June 3, 2024',
                                    title: 'Normal Condition',
                                    content: 'All looks good with this hive.',
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.only(left: 0, bottom: 22, top: 8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
