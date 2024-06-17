
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:line_icons/line_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:intl/intl.dart';
class HiveVideos extends StatefulWidget {
  final int hiveId;
  final String token;

  const HiveVideos({Key? key, required this.hiveId, required this.token}) : super(key: key);

  @override
  State<HiveVideos> createState() => _HiveVideosState();
}

class _HiveVideosState extends State<HiveVideos> {
  List<Map<String, dynamic>> videos = [];
  late DateTime _startDate;
  late DateTime _endDate;
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(Duration(days: 6));
    fetchVideos(widget.hiveId, _startDate, _endDate, _currentPage);
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
        _startDate = picked.start;
        _endDate = picked.end;
        videos.clear();
        _currentPage = 1;
        fetchVideos(widget.hiveId, _startDate, _endDate, _currentPage);
      });
    }
  }

  Future<void> fetchVideos(int hiveId, DateTime startDate, DateTime endDate, int page) async
  {
    //if (_isFetching || !_hasMore) return;

    setState(() {
      _isFetching = true;
    });

    try {
      String sendToken = "Bearer ${widget.token}";
      String formattedStartDate = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      String formattedEndDate = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";
      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var request = http.Request('GET', Uri.parse('https://www.ademnea.net/api/v1/hives/$hiveId/videos/$formattedStartDate/$formattedEndDate?page=$page'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print("Response body: $responseBody");
        final jsonData = jsonDecode(responseBody);
        List<dynamic> videoData = jsonData['data'];

        setState(() {
          videos.addAll(videoData.map((video) {
            return {
              'path': 'https://www.ademnea.net/${video['path'].replaceFirst("public/", "")}',
              'date': video['date']
            };
          }).toList());
          _isFetching = false;
          _hasMore = videoData.length == 10;
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (error) {
      print('Error fetching videos: $error');
      setState(() {
        _isFetching = false;
      });
    }
  }

  void _onScrollEnd(BuildContext context) {
    if (_isFetching || !_hasMore) return;

    _currentPage++;
    fetchVideos(widget.hiveId, _startDate, _endDate, _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
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
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Color.fromARGB(255, 206, 109, 40),
                          size: 65,
                        ),
                      ),
                      const SizedBox(
                        width: 55,
                      ),
                      Text(
                        'Hive ${widget.hiveId} videos',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: const Icon(
                          LineIcons.calendar,
                          color: Color.fromARGB(255, 206, 109, 40),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  _onScrollEnd(context);
                }
                return false;
              },
              child: ListView.builder(
                itemCount: videos.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < videos.length) {
                    return VideoItem(
                      videoUrl: videos[index]['path'],
                      date: videos[index]['date'],
                      hiveId: widget.hiveId,
                    );
                  } else {
                    return _isFetching ? _buildProgressIndicator() : Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String videoUrl;
  final String date;
  final int hiveId;

  const VideoItem({
    Key? key,
    required this.videoUrl,
    required this.date,
    required this.hiveId,
  }) : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late ChewieController _chewieController;
  bool _errorOccurred = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    try {
      _chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)),
        autoInitialize: true,
        looping: true,
        aspectRatio: 16/9,
        allowPlaybackSpeedChanging: false,
        autoPlay: false,
        showControls: true,
        errorBuilder: (context, errorMessage) {
          _errorOccurred = true;
          return const Center(
            child: Text(
              'Failed to load video',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );
    } catch (e) {
      _errorOccurred = true;
      print('Error initializing video player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(widget.date));
    if (_errorOccurred) {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey.withOpacity(0.5),
        child: const Center(
          child: Text(
            'Unsupported video format',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 180,
            child: Chewie(
              controller: _chewieController,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hive ID: ${widget.hiveId}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Date Taken: $formattedDate',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

