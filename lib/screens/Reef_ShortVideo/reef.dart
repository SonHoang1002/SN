import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateMoment/camera_moment_controller.dart';
import 'package:social_network_app_mobile/screens/Reef_ShortVideo/reef_center.dart';
import 'package:social_network_app_mobile/screens/Reef_ShortVideo/reef_footer.dart';
import 'package:social_network_app_mobile/screens/Reef_ShortVideo/reef_header.dart';
import 'package:social_network_app_mobile/screens/Reef_ShortVideo/reef_settings/reef_setting_main.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class Reef extends ConsumerStatefulWidget {
  const Reef({super.key});

  @override
  ConsumerState<Reef> createState() => _ReefState();
}

class _ReefState extends ConsumerState<Reef> {
  List momentSuggests = [];

  @override
  Widget build(BuildContext context) {
    momentSuggests = ref.watch(momentControllerProvider).momentSuggest;

    return momentSuggests.isNotEmpty
        ? Column(
            children: [
              Container(
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
                    ReefFooter(
                      firstFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CameraMomentController()));
                      },
                      secondFunction: () {
                        
                        pushCustomCupertinoPageRoute(
                            context, const UserPageHome(),);
                      },
                    )
                  ],
                ),
              ),
              const CrossBar(
                height: 7,
                opacity: 0.2,
              ),
            ],
          )
        : const SizedBox();
  }

  handleSettingHeader() {
    showCustomBottomSheet(context, 170,
        title: "",
        isNoHeader: true,
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
              changeBackground: Theme.of(context).colorScheme.background,
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              changeBackground: Theme.of(context).colorScheme.background,
              function: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (ctx) => const ReefSettingMain()));
              },
            ),
          ],
        ));
  }
}
