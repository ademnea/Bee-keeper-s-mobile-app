import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:line_icons/line_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:HPGM/photo_view_page.dart';

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
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(Duration(days: 6));
    fetchPhotos(widget.hiveId, _startDate, _endDate);
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
        fetchPhotos(widget.hiveId, _startDate, _endDate);
      });

    }
  }

  Future<void> fetchPhotos(int hiveId,DateTime startDate, DateTime endDate) async {
    try {
      String sendToken = "Bearer ${widget.token}";
    //  String sendToken = "Bearer ${widget.token}";
      String formattedStartDate = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      String formattedEndDate = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://www.ademnea.net/api/v1/hives/$hiveId/images/$formattedStartDate/$formattedEndDate'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseBody);

        //  print(jsonData);

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
                                'Hive ${widget.hiveId} images',
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
                                //  fetchPhotos(widget.hiveId);
                                },
                                icon: const Icon(
                                  LineIcons.alternateCloudDownload,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                label: const Text('Download data'),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () {
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
                                    //  parent: AlwaysScrollableScrollPhysics(),
                                    ),
                                padding: const EdgeInsets.all(1.0),
                                itemCount: photos.length,
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
                                            photos: photos,
                                            index: index,
                                          ),
                                        ),
                                      ),
                                      child: Hero(
                                        tag: photos[index],
                                        child: CachedNetworkImage(
                                          imageUrl: photos[index],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(color: Colors.grey),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.red.shade400,
                                          ),
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
