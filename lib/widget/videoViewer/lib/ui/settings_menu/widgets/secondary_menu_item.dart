import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/data/repositories/video.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/widgets/helpers.dart';


class SecondaryMenuItem extends StatelessWidget {
  const SecondaryMenuItem({
    Key? key,
    required this.onTap,
    required this.text,
    required this.selected,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final query = VideoQuery();
    final metadata = query.videoMetadata(context, listen: false);
    final style = metadata.style.settingsStyle;

    return CustomInkWell(
      onTap: onTap,
      child: Padding(
        padding: style.paddingSecondaryMenuItems,
        child: CustomText(
          text: text,
          selected: selected,
        ),
      ),
    );
  }
}
