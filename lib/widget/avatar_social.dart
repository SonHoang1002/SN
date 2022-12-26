import 'package:flutter/material.dart';

class AvatarSocial extends StatelessWidget {
  final double width;
  final double height;
  final String path;
  final bool? isGroup;

  const AvatarSocial(
      {Key? key,
      required this.width,
      required this.height,
      required this.path,
      this.isGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          isGroup != null && isGroup == true ? 10 : width / 2),
      child: Image.network(
        width: width,
        height: height,
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Text("Error"),
      ),
    );
  }
}
