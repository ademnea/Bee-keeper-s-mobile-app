import 'package:farmer_app/photo_view_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class NewVideos extends StatefulWidget {
  final int hiveId;
  final String token;

  const NewVideos({Key? key, required this.hiveId, required this.token})
      : super(key: key);

  @override
  State<NewVideos> createState() => _NewVideosState();
}

class _NewVideosState extends State<NewVideos> {
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
      body: Column(
        children: [
          Text("myvideos"),
          Divider(),
          AspectRatio(
            aspectRatio: 16 / 9,
            // child: Chewie(controller: _chewieController),
          ),
        ],
      ),
    );
  }
}
