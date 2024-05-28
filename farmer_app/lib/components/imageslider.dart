import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageUrls;

  const ImageSlider({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.9,
        height: 200,
        autoPlay: true,
      ),
      items: imageUrls.map((url) {
        return Image.network(url, width: 500, fit: BoxFit.cover);
      }).toList(),
    );
  }
}
