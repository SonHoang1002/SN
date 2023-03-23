import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/data/repositories/video.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/entities/subtitle.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/settings_menu/widgets/secondary_menu.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/settings_menu/widgets/secondary_menu_item.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/widgets/helpers.dart';

import '../../../domain/entities/video_source.dart';


class CaptionMenu extends StatelessWidget {
  const CaptionMenu({Key? key}) : super(key: key);

  void onTap(
    BuildContext context,
    VideoViewerSubtitle? subtitle,
    String subtitleName,
  ) async {
    final query = VideoQuery();
    final video = query.video(context);
    video.closeAllSecondarySettingsMenus();
    await video.changeSubtitle(subtitle: subtitle, subtitleName: subtitleName);
  }

  @override
  Widget build(BuildContext context) {
    final query = VideoQuery();
    final video = query.video(context, listen: true);
    final metadata = query.videoMetadata(context, listen: true);

    final activeSourceName = video.activeSourceName;
    final activeCaption = video.activeCaption;
    final none = metadata.language.captionNone;

    return SecondaryMenu(children: [
      CustomInkWell(
        onTap: () => onTap(context, null, none),
        child: CustomText(
          text: none,
          selected: activeCaption == none || activeCaption == null,
        ),
      ),
      for (MapEntry<String, VideoSource> entry in video.source!.entries)
        if (entry.key == activeSourceName && entry.value.subtitle != null)
          for (MapEntry<String, VideoViewerSubtitle> subtitle
              in entry.value.subtitle!.entries)
            SecondaryMenuItem(
              onTap: () {
                onTap(
                  context,
                  subtitle.value,
                  subtitle.key,
                );
              },
              text: subtitle.key,
              selected: subtitle.key == activeCaption,
            ),
    ]);
  }
}
