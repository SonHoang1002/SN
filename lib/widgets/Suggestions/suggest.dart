import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Reef_ShortVideo/reef_settings/reef_setting_main.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Suggestions/suggest_center.dart';
import 'package:social_network_app_mobile/widgets/Suggestions/suggest_footer.dart';
import 'package:social_network_app_mobile/widgets/Suggestions/suggest_header.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class Suggest extends ConsumerStatefulWidget {
  final dynamic type;
  final Widget? headerWidget;
  // độ rộng của suggest items
  final double? viewportFraction;
  final Widget? subHeaderWidget;
  // khắc phục tình trạng lắng nghe thay đổi chậm của riverpod
  final Function? reloadFunction;

  final dynamic footerTitle;

  const Suggest(
      {super.key,
      required this.type,
      this.headerWidget,
      this.subHeaderWidget,
      this.reloadFunction,
      this.viewportFraction,
      this.footerTitle});

  @override
  ConsumerState<Suggest> createState() => _SuggestState();
}

class _SuggestState extends ConsumerState<Suggest> {
  List<dynamic> listData = [];
  bool _isShowSuggest = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (widget.type == suggestFriends) {
        await ref
            .read(friendControllerProvider.notifier)
            .getListFriendSuggest(null);
      }
      if (widget.type == suggestGroups) {
        await ref
            .read(groupListControllerProvider.notifier)
            .getListGroupAdminMember({'tab': "member", 'limit': 10});
      }
    });
  }

  _loadMoreData() {
    if (widget.type == suggestFriends) {
      String maxId =
          ref.watch(friendControllerProvider).friendSuggestions.last['id'];
      ref.read(friendControllerProvider.notifier).getListFriendSuggest({
        "max_id": maxId,
      });
    } else if (widget.type == suggestGroups) {
      String maxId =
          ref.watch(groupListControllerProvider).groupMember.last['id'];
      ref.read(groupListControllerProvider.notifier).getListGroupAdminMember(
          {"max_id": maxId, 'tab': "member", 'limit': 10});
    }
  }

  _handleSettingHeader() {
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

              // greyColor[300],
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

  @override
  Widget build(BuildContext context) {
    if (widget.type == suggestFriends) {
      if (ref.read(friendControllerProvider).friendSuggestions.isNotEmpty) {
        listData = ref.read(friendControllerProvider).friendSuggestions;
      }
    }
    if (widget.type == suggestGroups) {
      if (ref.read(groupListControllerProvider).groupMember.isNotEmpty) {
        listData = ref.read(groupListControllerProvider).groupMember;
      }
    }

    return _isShowSuggest
        ? listData.isNotEmpty
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SuggestHeader(
                          settingFunction: () {
                            _handleSettingHeader();
                          },
                          closeFunction: () {
                            setState(() {
                              _isShowSuggest = false;
                            });
                          },
                          headerWidget: widget.headerWidget,
                          subHeaderWidget: widget.subHeaderWidget,
                        ),
                        buildSpacer(height: 10),
                        SuggestCenter(
                            type: widget.type,
                            suggestList: listData,
                            viewportFraction: widget.viewportFraction,
                            loadMoreFunction: () {
                              _loadMoreData();
                            },
                            reloadFunction: () {
                              widget.reloadFunction;
                              setState(() {});
                            }),
                        buildSpacer(height: 10),
                        SuggestFooter(
                          suggestData: listData,
                          title: widget.footerTitle,
                          function: () {},
                        )
                      ],
                    ),
                  ),
                  const CrossBar(
                    height: 5,
                  ),
                ],
              )
            : const SizedBox()
        : GeneralComponent(
            [
              buildTextContent("Đã ẩn phần những người bạn có thể biết", true,
                  fontSize: 14),
              buildSpacer(height: 3),
              buildTextContent(
                  "Tạm thời, phần Những người bạn có thể biết đã ẩn khỏi Bảng Feed",
                  false,
                  fontSize: 13)
            ],
            prefixWidget: Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Icon(
                FontAwesomeIcons.xmarkSquare,
                size: 20,
              ),
            ),
            suffixWidget: ButtonPrimary(
              label: 'Hoàn tác',
              colorButton: greyColor[300],
              handlePress: () {
                setState(() {
                  _isShowSuggest = true;
                });
              },
            ),
            suffixFlexValue: 11,
            padding: EdgeInsets.zero,
            changeBackground: transparent,
          );
  }
}
