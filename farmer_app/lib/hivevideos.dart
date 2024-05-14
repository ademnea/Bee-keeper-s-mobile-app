import 'package:farmer_app/photo_view_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HiveVideos extends StatefulWidget {
  final int hiveId;
  final String token;

  const HiveVideos({Key? key, required this.hiveId, required this.token})
      : super(key: key);

  @override
  State<HiveVideos> createState() => _HiveVideosState();
}

class _HiveVideosState extends State<HiveVideos> {
  List<String> videos = [];

  @override
  void initState() {
    super.initState();

    fetchVideos(widget.hiveId);
  }

  Future<void> fetchVideos(int hiveId) async {
    try {
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://www.ademnea.net/api/v1/hives/$hiveId/videos/2023-12-12/2024-12-12'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print(response);

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseBody);

        print(jsonData);

        List<dynamic> videoPaths = jsonData['paths'];

        setState(() {
          videos = videoPaths
              .map<String>((path) =>
                  'https://www.ademnea.net/${path.replaceFirst("public/", "")}')
              .toList();
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (error) {
      print('Error fetching videos: $error');
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
                                width: 55,
                              ),
                              Text(
                                'Hive ${widget.hiveId} videos',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
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
                  Container(
                    height: 760,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.brown[300], // Set the background color here
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DefaultTabController(
                      length: 3, // Number of tabs
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                child: GridView.builder(
                                  physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics(),
                                  ),
                                  padding: const EdgeInsets.all(1.0),
                                  itemCount: videos.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(1.0),
                                      child: InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PhotoViewPage(
                                              photos: videos,
                                              index: index,
                                            ),
                                          ),
                                        ),
                                        child: Hero(
                                          tag: videos[index],

                                          //this is where a video is specified.
                                          child: CachedNetworkImage(
                                            imageUrl: videos[index],
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(color: Colors.grey),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.red.shade400,
                                            ),
                                          ),

                                          // video ends here ends here
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
