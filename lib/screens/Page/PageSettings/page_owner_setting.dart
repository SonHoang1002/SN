import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/blue_certified_widget.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

class PageOwnerSetting extends ConsumerStatefulWidget {
  final dynamic data;
  const PageOwnerSetting({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageOwnerSettingState();
}

class _PageOwnerSettingState extends ConsumerState<PageOwnerSetting> {
  bool accountSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Chủ tài khoản trang'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Chủ tài khoản của Trang",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarSocial(
                      width: 60,
                      height: 60,
                      object: widget.data["account_holder"],
                      path: widget.data["account_holder"] != null &&
                              widget.data["account_holder"]['avatar_media'] !=
                                  null
                          ? widget.data["account_holder"]['avatar_media']
                              ['preview_url']
                          : linkAvatarDefault),
                  const SizedBox(
                    width: 7,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.data["account_holder"]?['display_name'] ??
                                'Không xác định',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          widget.data["account_holder"] != null &&
                                  widget.data["account_holder"]?["certified"]
                              ? buildBlueCertifiedWidget()
                              : const SizedBox()
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: const Text(
                  "Mỗi Trang sẽ được cấu hình một tài khoản, chỉ có Quản trị viên của Trang mới được chọn làm chủ tài khoản và tài khoản đó phải được Emso xác minh danh tính.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Cập nhật chủ tài khoản của Trang",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () {
                  buildFilterUsersSelectionBottomSheet();
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: greyColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: !accountSelected
                              ? const Text(
                                  'Cập nhật chủ tài khoản',
                                  style:
                                      TextStyle(fontSize: 16, color: greyColor),
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AvatarSocial(
                                        width: 40,
                                        height: 40,
                                        object: widget.data["account_holder"],
                                        path: widget.data["account_holder"] !=
                                                    null &&
                                                widget.data["account_holder"]
                                                        ['avatar_media'] !=
                                                    null
                                            ? widget.data["account_holder"]
                                                ['avatar_media']['preview_url']
                                            : linkAvatarDefault),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              widget.data["account_holder"]
                                                      ?['display_name'] ??
                                                  'Không xác định',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                            widget.data["account_holder"] !=
                                                        null &&
                                                    widget.data[
                                                            "account_holder"]
                                                        ?["certified"]
                                                ? buildBlueCertifiedWidget()
                                                : const SizedBox()
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              accountSelected
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonPrimary(
                        label: 'Cập nhật',
                        handlePress: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ));
  }

  List test = [
    1,
    2,
    3,
  ];
  buildFilterUsersSelectionBottomSheet() {
    showCustomBottomSheet(context, 420,
        title: "Cập nhật chủ tài khoản",
        isHaveCloseButton: false,
        bgColor: Colors.grey[300], widget: StatefulBuilder(
      builder: (ctx, setStatefull) {
        return Container(
          height: 350,
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: test.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      accountSelected = true;
                    });
                    popToPreviousScreen(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AvatarSocial(
                                  width: 40,
                                  height: 40,
                                  object: widget.data["account_holder"],
                                  path: widget.data["account_holder"] != null &&
                                          widget.data["account_holder"]
                                                  ['avatar_media'] !=
                                              null
                                      ? widget.data["account_holder"]
                                          ['avatar_media']['preview_url']
                                      : linkAvatarDefault),
                              const SizedBox(
                                width: 7,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.data["account_holder"]
                                                ?['display_name'] ??
                                            'Không xác định',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      widget.data["account_holder"] != null &&
                                              widget.data["account_holder"]
                                                  ?["certified"]
                                          ? buildBlueCertifiedWidget()
                                          : const SizedBox()
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          buildSpacer(height: 10)
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    ));
  }
}
