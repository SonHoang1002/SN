import 'package:flutter/material.dart';

class AppBarNetworkRoundedImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  // ignore: use_key_in_widget_constructors
  const AppBarNetworkRoundedImage(
      {required this.imageUrl, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.black.withOpacity(0.05)),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            onError: (exception, stackTrace) => const Text("Error"),
            fit: BoxFit.cover,
          ),
        ));
  }
}
