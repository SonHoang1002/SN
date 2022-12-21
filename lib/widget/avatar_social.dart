import 'package:flutter/material.dart';

class AvatarSocial extends StatelessWidget {
  final double width;
  final double height;
  final String path;

  const AvatarSocial(
      {Key? key, required this.width, required this.height, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(width / 2),
      child: Image.network(
        width: width,
        height: height,
        path,
        fit: BoxFit.cover,
      ),
    );
  }
}
