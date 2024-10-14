import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class SlideshowWidget extends StatelessWidget {
  const SlideshowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: 300, // Adjusted height for the slideshow
      initialPage: 0,
      indicatorColor: Colors.blue,
      indicatorBackgroundColor: Colors.grey,
      onPageChanged: (value) {
        print('Page changed: $value');
      },
      autoPlayInterval: 3000, // Set the interval for autoplay
      isLoop: true,
      children: [
        Image.asset(
          'assets/images/IMG_3041.JPG',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/IMG_3044.JPG',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/IMG_3058.JPG',
          fit: BoxFit.cover,
        ),
      ], // Enable looping
    );
  }
}
