import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageUrls = [
    'lib/images/njuki.jpg',
    'lib/images/njuki.jpg',
    'lib/images/njuki.jpg',
    // Add more image URLs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        //aspectRatio: 1 / 0.5,
        viewportFraction: 0.9,
        height: 200,
        autoPlay: true,
      ),
      items: [
        // Add your image widgets here
        Image.asset('lib/images/njuki.jpg', width: 500, fit: BoxFit.cover),
        Image.asset('lib/images/njuki.jpg', width: 500, fit: BoxFit.cover),
        Image.asset('lib/images/njuki.jpg', width: 500, fit: BoxFit.cover),
        // Add more images as needed
      ],
    );
  }
}
