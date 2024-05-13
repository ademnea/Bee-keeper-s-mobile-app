import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmer_app/photo_view_page.dart';

class Media extends StatefulWidget {
  final int hiveId;
  final String token;

  const Media({Key? key, required this.hiveId, required this.token})
      : super(key: key);

  @override
  State<Media> createState() => _MediaState();
}

class _MediaState extends State<Media> {
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
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: GridView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.all(1.0),
          itemCount: photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(1.0),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhotoViewPage(photos: photos, index: index),
                  ),
                ),
                child: Hero(
                  tag: photos[index],
                  child: CachedNetworkImage(
                    imageUrl: photos[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
