import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/data/repositories/video.dart';

class SplashCircularIcon extends StatelessWidget {
  const SplashCircularIcon({
    Key? key,
    required this.child,
    required this.onTap,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final Widget? child;
  final void Function() onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    required this.selected,
  }) : super(key: key);

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final metadata = VideoQuery().videoMetadata(context, listen: true);
    final style = metadata.style.settingsStyle;

    return Padding(
      padding: const Margin.horizontal(8),
      child: Row(children: [
        Expanded(
          child: Text(
            text,
            style: metadata.style.textStyle.merge(
              const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        if (selected) style.selected,
      ]),
    );
  }
}

class CustomInkWell extends StatelessWidget {
  const CustomInkWell({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.white.withOpacity(0.2),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
