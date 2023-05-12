import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Moment/moment.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_video.dart';
import 'package:social_network_app_mobile/screen/Moment/video_description.dart';

class ReefItem extends StatelessWidget {
  final dynamic reefData;
  const ReefItem({required this.reefData, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        // pushCustomCupertinoPageRoute(context, const Moment());
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        height: size.height * 0.45,
        width: size.width * 0.5,
        decoration:
            BoxDecoration(color: red, borderRadius: BorderRadius.circular(10)),
        child: reefData != null && reefData != ""
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MomentVideo(
                  moment: reefData,
                ),
              )
            : null,
      ),
    );
  }
}

