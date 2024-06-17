import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:line_icons/line_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; // for date formatting
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
  List<Map<String, String>> photos = [];
  late DateTime _startDate;
  late DateTime _endDate;
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(Duration(days: 6));
    fetchPhotos(widget.hiveId, _startDate, _endDate, _currentPage);

    // Add listener to detect when the user reaches the end of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more photos if there are more to load
        if (_hasMore && !_isFetching) {
          fetchPhotos(widget.hiveId, _startDate, _endDate, _currentPage);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        photos.clear();
        _currentPage = 1;
        fetchPhotos(widget.hiveId, _startDate, _endDate, _currentPage);
      });
    }
  }

  Future<void> fetchPhotos(
      int hiveId, DateTime startDate, DateTime endDate, int page) async {
    if (_isFetching || !_hasMore) return;

    setState(() {
      _isFetching = true;
    });

    try {
      String sendToken = "Bearer ${widget.token}";
      String formattedStartDate =
          "${DateFormat('yyyy-MM-dd').format(startDate)}";
      String formattedEndDate =
          "${DateFormat('yyyy-MM-dd').format(endDate)}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var response = await http.get(
        Uri.parse(
            'https://www.ademnea.net/api/v1/hives/$hiveId/images/$formattedStartDate/$formattedEndDate?page=$page'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> data = jsonData['data'];
        bool hasMore = jsonData['pagination']['next_page_url'] != null;

        setState(() {
          photos.addAll(data.map<Map<String, String>>((item) => {
            'date': item['date'],
            'path': 'https://www.ademnea.net/${item['path'].replaceAll('public/', '')}' // Remove 'public/' from path
          }).toList());
          _isFetching = false;
          _hasMore = hasMore;
          _currentPage++;
        });
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (error) {
      print('Error fetching photos: $error');
      setState(() {
        _isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          controller: _scrollController,
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
                                physics: const BouncingScrollPhysics(),
                                controller: _scrollController,
                                padding: const EdgeInsets.all(1.0),
                                itemCount: photos.length + (_hasMore ? 1 : 0),
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 1.0,
                                  mainAxisSpacing: 1.0,
                                ),
                                itemBuilder: (context, index) {
                                  if (index < photos.length) {
                                    return InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PhotoViewPage(
                                            photos: photos
                                                .map((photo) => photo['path']!)
                                                .toList(),
                                            index: index,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Hero(
                                            tag: photos[index]['path']!,
                                            child: CachedNetworkImage(
                                              imageUrl: photos[index]['path']!,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Container(
                                                      color: Colors.grey),
                                              errorWidget:
                                                  (context, url, error) =>
                                                  Container(
                                                    color: Colors.red.shade400,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DateFormat('yyyy-MM-dd hh:mm:ss')
                                                .format(DateTime.parse(
                                                photos[index]['date']!)),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (_isFetching) {
                                    return _buildProgressIndicator();
                                  } else {
                                    return Container();
                                  }
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

  Widget _buildProgressIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
