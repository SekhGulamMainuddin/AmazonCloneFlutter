import 'package:amazon_clone/constants/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {
  const CarouselImage({Key? key}) : super(key: key);

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: GlobalVariables.carouselImages
              .map(
                (image) => Image.network(
                  image,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              )
              .toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            height: 200,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        Container(
          height: 180,
          alignment: Alignment.bottomCenter,
          child: DotsIndicator(
            dotsCount: GlobalVariables.carouselImages.length,
            position: currentIndex.toDouble(),
            decorator: DotsDecorator(
              activeColor: GlobalVariables.selectedNavBarColor,
            ),
          ),
        ),
      ],
    );
  }
}
