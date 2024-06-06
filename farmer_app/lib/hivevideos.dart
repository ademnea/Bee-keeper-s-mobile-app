import 'package:farmer_app/photo_view_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:line_icons/line_icons.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(Duration(days: 6));
    fetchVideos(widget.hiveId, _startDate, _endDate);

  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null && picked.start != null && picked.end != null) {
      setState(() {
        _startDate = picked.start!;
        _endDate = picked.end!;
        fetchVideos(widget.hiveId, _startDate, _endDate);
      });

    }
  }

  Future<void> fetchVideos(int hiveId, DateTime startDate, DateTime endDate) async {
    try {
      String sendToken = "Bearer ${widget.token}";
      String formattedStartDate = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      String formattedEndDate = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";
      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://www.ademnea.net/api/v1/hives/$hiveId/videos/$formattedStartDate/$formattedEndDate'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseBody);

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
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () async {
                                 // fetchVideos(widget.hiveId);
                                },
                                icon: const Icon(
                                  LineIcons.alternateCloudDownload,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                label: const Text('Download Data'),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: ()
                                {
                                  _selectDate(context);
                                },
                                icon: const Icon(
                                  LineIcons.calendar,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                label: const Text('Choose Date'),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(
                                    // parent: AlwaysScrollableScrollPhysics(),
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
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PhotoViewPage(
                                              photos: videos,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: videos[index],
                                        child: VideoThumbnail(
                                          videoUrl: videos[index],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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

class VideoThumbnail extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnail({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    //dispose();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    //
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 9 / 9, // Adjust aspect ratio if necessary
      placeholder: Container(
        color: Color.fromARGB(255, 206, 109, 40),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Chewie(controller: _chewieController),
        ));
      },
      child: Stack(
        // alignment: Alignment.center,
        children: [
          Chewie(
            controller: _chewieController.copyWith(autoPlay: false),
          ),
          const Icon(
            Icons.play_arrow,
            size: 40,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
