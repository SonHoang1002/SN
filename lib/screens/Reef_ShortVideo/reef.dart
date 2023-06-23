import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/moment_api.dart';
import 'package:social_network_app_mobile/data/moment.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateMoment/create_moment.dart';
import 'package:social_network_app_mobile/screens/Moment/moment_pageview.dart';
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

class Reef extends ConsumerStatefulWidget {
  const Reef({super.key});

  @override
  ConsumerState<Reef> createState() => _ReefState();
}

class _ReefState extends ConsumerState<Reef> {
  static const channelName = 'startActivity/VideoEditorChannel';
  static const platform = MethodChannel(channelName);
  String _errorMessage = '';

  List momentSuggests = [];
  @override
  void initState() {
    super.initState();
    // if (mounted) {
    Future.delayed(Duration.zero, () async {
      ref
          .read(momentControllerProvider.notifier)
          .getListMomentSuggest({"limit": 5});
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    momentSuggests =
        ref.watch(momentControllerProvider).momentSuggest.isNotEmpty
            ? ref.watch(momentControllerProvider).momentSuggest
            : momentSuggests.isEmpty
                ? moments.sublist(1, 7)
                : momentSuggests;
    momentSuggests.shuffle();
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
          ReefFooter(
            firstFunction: () {
              _startVideoEditorDefault();
            },
            secondFunction: () {
              pushCustomCupertinoPageRoute(context, const UserPageHome());
            },
          )
        ],
      ),
    );
  }

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

  Future<void> _initVideoEditor() async {
    const methodInitVideoEditor = 'InitBanubaVideoEditor';
    const String LICENSE_TOKEN =
        "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";
    await platform.invokeMethod(methodInitVideoEditor, LICENSE_TOKEN);
  }

  Future<void> _startVideoEditorDefault() async {
    try {
      await _initVideoEditor();
      const methodStartVideoEditor = 'StartBanubaVideoEditor';
      final result = await platform.invokeMethod(methodStartVideoEditor);
      _handleExportResult(result);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  void _handleExportResult(dynamic result) {
    debugPrint('Export result = $result');
    if (result is Map) {
      const argExportedVideoFile = 'exportedVideoFilePath';
      final exportedVideoFilePath = result[argExportedVideoFile];
      const argExportedVideoCoverPreviewPath = 'exportedVideoCoverPreviewPath';
      final exportedVideoCoverPreviewPath =
          result[argExportedVideoCoverPreviewPath];
      if (exportedVideoCoverPreviewPath != null &&
          exportedVideoFilePath != null) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => CreateMoment(
                    imageCover: exportedVideoCoverPreviewPath,
                    videoPath: exportedVideoFilePath)));
      }
    }
  }

  void _handlePlatformException(PlatformException exception) {
    debugPrint("Error: '${exception.message}'.");
    const errEditorLicenseRevokedCode = 'ERR_VIDEO_EDITOR_LICENSE_REVOKED';
    const errEditorLicenseRevokedMessage =
        'License is revoked or expired. Please contact Banuba https://www.banuba.com/faq/kb-tickets/new';
    const errEditorNotInitializedCode = 'ERR_VIDEO_EDITOR_NOT_INITIALIZED';
    const errEditorNotInitializedMessage =
        'Banuba Video Editor SDK is not initialized: license token is unknown or incorrect.\nPlease check your license token or contact Banuba';
    String errorMessage = '';

    switch (exception.code) {
      case errEditorLicenseRevokedCode:
        errorMessage = errEditorLicenseRevokedMessage;
        break;
      case errEditorNotInitializedCode:
        errorMessage = errEditorNotInitializedMessage;
        break;
      default:
        errorMessage = 'unknown error';
    }

    setState(() {
      _errorMessage = errorMessage;
    });
  }
}
