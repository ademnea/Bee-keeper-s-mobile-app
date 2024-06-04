import 'package:farmer_app/components/imageslider.dart';
import 'package:farmer_app/parameter_tab_view.dart';
import 'package:farmer_app/splashscreen.dart';
import 'package:farmer_app/components/notificationbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HiveDetails extends StatefulWidget {
  final int hiveId;
  final String token;
  const HiveDetails({Key? key, required this.hiveId, required this.token})
      : super(key: key);

  @override
  State<HiveDetails> createState() => _HiveDetailsState();
}

class _HiveDetailsState extends State<HiveDetails> {
  List<String> photos = [];

  @override
  void initState() {
    super.initState();
    fetchPhotos(widget.hiveId);
  }

  Future<void> fetchPhotos(int hiveId) async {
    try {
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://www.ademnea.net/api/v1/hives/$hiveId/images/2023-12-12/2024-12-12'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseBody);

        print(jsonData);

        List<dynamic> imagePaths = jsonData['paths'];

        setState(() {
          photos = imagePaths
              .map<String>((path) =>
                  'https://www.ademnea.net/${path.replaceFirst("public/", "")}')
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

                          //image starts here
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
                                      fontSize: 20),
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
                      )),

                  //image starts here
                  if (photos.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ImageSlider(
                        imageUrls: photos,
                      ),
                    ),

                  //first card
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 600,
                      child: Card(
                        clipBehavior: Clip.antiAlias,

                        color: Colors
                            .brown[300], // Set the background color to gray
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            //row
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
                                const SizedBox(
                                  width: 10,
                                ),
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
                              height: 1, // Set the height of the divider
                              color: Colors
                                  .grey[350], // Set the color of the divider
                              thickness: 2, // Set the thickness of the divider
                            ),

                            //row
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Splashscreen(),
                                      ),
                                    );
                                  },
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

                            //notifications start here.
                            Container(
                              child: const Column(
                                children: [
                                  //notifications
                                  NotificationComponent(
                                    date: 'June 3, 2024',
                                    title: 'Normal Condition',
                                    content: 'All looks good with this hive.',
                                  ),
                                ],
                              ),
                            ),
//notifications end
                            const Padding(
                              padding:
                                  EdgeInsets.only(left: 0, bottom: 22, top: 8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 20,
                  ),
                  // Add other cards here
                ],
              ),
            ),
          ),
        ),
      ),
//bottom navigation bar.
    );
  }
}
