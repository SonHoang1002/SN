 import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

// int _currentPage = 0;
final images = [
  "https://snapi.emso.asia/system/media_attachments/files/108/853/138/654/944/677/original/cc4c8fd4be1d7a96.jpg",
  "https://cdn.baoquocte.vn/stores/news_dataimages/nguyenhong/022017/06/11/111152_4.jpg",
  "https://hanoimoi.com.vn/Uploads/Album/20161221/faa4de54-2342-4edd-a4ea-3850b553ccec.jpg",
  "https://png.pngtree.com/thumb_back/fh260/background/20200417/pngtree-color-creative-texture-mountain-background-image_334026.jpg",
  "https://cdn.baoquocte.vn/stores/news_dataimages/linhnguyen/122019/01/07/4254_panorama2.jpg"
];
Widget buildBanner(BuildContext context,
    {double? height = 100, double? width}) {


  return CarouselSlider(
    items: images.map((url) {
      return Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          margin: const EdgeInsets.all(5.0),
          child: ImageCacheRender(
            path: url,
            width: width,
            height: 200.0,
          ),
        ),
      );
    }).toList(),
    options: CarouselOptions(
      aspectRatio: MediaQuery.of(context).size.width /
          MediaQuery.of(context).size.height,
      autoPlay: true,
      // enlargeCenterPage: true,
      height: 200,
    ),
  );
}
