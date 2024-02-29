import 'package:farmer_app/humidity.dart';
import 'package:farmer_app/photo_view_page.dart';
import 'package:farmer_app/temperature.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Media extends StatefulWidget {
  const Media({super.key});

  @override
  State<Media> createState() => _MediaState();
}

class _MediaState extends State<Media> {
  final List<String> photos = [
    'https://m.media-amazon.com/images/I/71IeYNcBYdL._SX679_.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/e/e7/Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg',
    'https://hairstyleonpoint.com/wp-content/uploads/2015/09/4ce06e936dcd5e5c5c3e44be9edbc8ff.jpg',
    'https://bsmedia.business-standard.com/_media/bs/img/article/2020-12/11/full/1607656152-0479.jpg',
    'https://cdn.pixabay.com/photo/2015/04/19/08/32/marguerite-729510__340.jpg',
  ];

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
                                child: const Icon(
                                  Icons.chevron_left_rounded,
                                  color: Color.fromARGB(255, 206, 109, 40),
                                  size: 65,
                                ),
                              ),
                              const SizedBox(
                                width: 90,
                              ),
                              const Text(
                                'Monitors',
                                style: TextStyle(
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
                    )),

                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.brown[300], // Set the background color here
                    // borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
//container components begin.
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: TextButton(
                              onPressed: () {
                                // Button pressed action
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Temperature(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: Colors.grey[300],
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Temperature',
                                    style: TextStyle(
                                      color:
                                          Colors.black, // Set text color here
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //second button

                          Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Button pressed action
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Humidity(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: Colors.grey[300],
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Humidity',
                                    style: TextStyle(
                                      color:
                                          Colors.black, // Set text color here
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //third button
                          TextButton(
                            onPressed: () {
                              // Button pressed action
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.orange[400],
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Media',
                                  style: TextStyle(
                                    color: Colors.black, // Set text color here
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //buttons end
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          'Media',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[300]),
                        ),
                      ),
                      // end of buttons row.
                    ],
                  ),
                ),
                //shaded container ends.
                //start of the media

                Container(
                  padding: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: GridView.builder(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: EdgeInsets.all(1.0),
                      itemCount: photos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(1.0),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PhotoViewPage(photos: photos, index: index),
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
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
