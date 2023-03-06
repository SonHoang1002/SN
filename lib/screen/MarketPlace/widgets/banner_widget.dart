 import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget buildBanner({double? height = 200,double? width  }) {
    final images = [
      "https://phathocdoisong.com/images/upload/image/201808/20180822184737_95608.jpg",
      "https://phathocdoisong.com/data/article/1534914214857444015.jpg",
      "https://phathocdoisong.com/images/upload/image/201808/20180822184738_55552.jpg",
      "https://phathocdoisong.com/images/upload/image/201808/20180822184738_32995.jpg",
      "https://chuahoaphuc.com/wp-content/uploads/2021/06/25-1-888x666.jpg"
    ];
    return CarouselSlider(
      items: images.map((url) {
        return Container(
          width: width,
          margin: const EdgeInsets.all(5.0),
          child: Image.network(url, fit: BoxFit.fitHeight),
        );
      }).toList(),
      options: CarouselOptions(
        // aspectRatio: 16 / 9,
        autoPlay: true,
        // enlargeCenterPage: true,
        height: height,
        
      ),
    );
  }