import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/moment_api.dart';
import 'package:social_network_app_mobile/data/moment.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_pageview.dart';
import 'package:social_network_app_mobile/screen/Reef_ShortVideo/reef_center.dart';
import 'package:social_network_app_mobile/screen/Reef_ShortVideo/reef_footer.dart';
import 'package:social_network_app_mobile/screen/Reef_ShortVideo/reef_header.dart';
import 'package:social_network_app_mobile/screen/Reef_ShortVideo/reef_settings/reef_setting_main.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';

class Reef extends ConsumerStatefulWidget {
  const Reef({super.key});

  @override
  ConsumerState<Reef> createState() => _ReefState();
}

class _ReefState extends ConsumerState<Reef> {
  List momentSuggests = [];
  @override
  void initState() {
    super.initState();
    // if (mounted) {
    Future.delayed(Duration.zero, () async {
      ref
          .read(momentControllerProvider.notifier)
          .getListMomentSuggest({"limit": 10});
      while (momentSuggests.isEmpty) {
        momentSuggests =
            await MomentApi().getListMomentSuggest({"limit": 10}) ?? moments;
      }
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    momentSuggests =
        ref.watch(momentControllerProvider).momentSuggest.isNotEmpty
            ? ref.watch(momentControllerProvider).momentSuggest
            : momentSuggests.isEmpty
                ? moments
                : momentSuggests;

    handleSettingHeader() {
      showCustomBottomSheet(context, 170, "",
          isHaveHeader: false,
          bgColor: Theme.of(context).colorScheme.background,
          widget: Column(
            children: [
              GeneralComponent(
                [
                  buildTextContent("Ẩn", false, fontSize: 15),
                  buildSpacer(height: 7),
                  buildTextContent("Ẩn bớt các bài viết tương tự", false,
                      fontSize: 12, colorWord: greyColor)
                ],
                prefixWidget: const Icon(
                  FontAwesomeIcons.rectangleXmark,
                  size: 18,
                ),
                // padding: EdgeInsets.zero,
                changeBackground: greyColor[300],
              ),
              buildSpacer(height: 10),
              GeneralComponent(
                [
                  buildTextContent("Quản lý Bảng feed", false, fontSize: 15),
                ],
                prefixWidget: const Icon(
                  FontAwesomeIcons.sliders,
                  size: 18,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                changeBackground: greyColor[300],
                function: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (ctx) => const ReefSettingMain()));
                },
              ),
            ],
          ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ReefHeader(
            function: () {
              handleSettingHeader();
            },
          ),
          buildSpacer(height: 10),
          ReefCenter(reefList: momentSuggests),
          buildSpacer(height: 10),
          const ReefFooter()
        ],
      ),
    );
  }
}
