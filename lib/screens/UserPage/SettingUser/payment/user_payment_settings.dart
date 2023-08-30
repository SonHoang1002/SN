import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_list_provider.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/payment/identity_verification.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/payment/identity_verification_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';

class UserPaymentSetting extends ConsumerStatefulWidget {
  const UserPaymentSetting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserPaymentSettingState();
}

class _UserPaymentSettingState extends ConsumerState<UserPaymentSetting> {
  Map<String, dynamic> accountSelected = {};
  List<dynamic> searchResults = [];
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CupertinoActivityIndicator(),
      ),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const AppBarTitle(title: "Bật kiếm tiền"),
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
            shape: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5)),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        buildSearchPageUserBottomSheet();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: greyColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: accountSelected.isEmpty
                              ? const Row(
                                  children: [
                                    Icon(Icons.search),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Tìm kiếm trang',
                                      style: TextStyle(
                                          fontSize: 16, color: greyColor),
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AvatarSocial(
                                        width: 40,
                                        height: 40,
                                        object: accountSelected,
                                        path: accountSelected.isEmpty ==
                                                    false &&
                                                accountSelected[
                                                        'avatar_media'] !=
                                                    null
                                            ? accountSelected['avatar_media']
                                                ['preview_url']
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
                                              accountSelected["type"] ==
                                                      "Account"
                                                  ? accountSelected[
                                                          'display_name'] ??
                                                      'Không xác định'
                                                  : accountSelected['title'] ??
                                                      'Không xác định',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    premiumExclusive("assets/Quangcaotrongluong.png",
                        "Quảng cáo trong luồng theo yêu cầu"),
                    premiumExclusive(
                        "assets/BVTT.png", "Kiếm tiền trong bài viết tức thì"),
                    premiumExclusive(
                        "assets/Binhluan.png", "Kiếm tiền trong bình luận"),
                    premiumExclusive("assets/Tangsao.png", "Tặng Sao"),
                    premiumExclusive("assets/Dangkytheodoi.png",
                        "Chương trình đăng ký theo dõi"),
                    premiumExclusive("assets/Congtacthuonghieu.png",
                        "Cộng tác với thương hiệu"),
                    const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Tiêu chí bật kiếm tiền",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    criteria("Tài khoản ít nhất phải hoạt động trên 30 ngày."),
                    criteria("Người dùng phải đủ 18 tuổi trở lên."),
                    criteria(
                        "Người dùng bật tính năng kiếm tiền khi đủ 1000 Follower."),
                    criteria(
                        "Trang bật tính năng kiếm tiền khi đủ 5000 Follower."),
                    accountSelected.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Divider(
                                  height: 20,
                                  thickness: 1,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ButtonPrimary(
                                    isGrey: accountSelected["earn_money"] &&
                                            accountSelected[
                                                "identity_verification"]
                                        ? true
                                        : false,
                                    label: accountSelected[
                                                "identity_verification"] ==
                                            false
                                        ? 'Xác minh danh tính'
                                        : accountSelected["earn_money"] &&
                                                accountSelected["earn_money"] !=
                                                    null
                                            ? 'Đã bật kiếm tiền'
                                            : 'Bật kiếm tiền',
                                    handlePress: () async {
                                      if (accountSelected[
                                              "identity_verification"] ==
                                          false) {
                                        if (accountSelected["type"] ==
                                            'Account') {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const IdentityVerification()));
                                        } else {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      IdentityVerificationPage(
                                                        data: accountSelected,
                                                      )));
                                        }
                                      } else if (accountSelected[
                                              "earn_money"] ==
                                          false) {
                                        var res = await PageApi()
                                            .activeEarnMoney({
                                          "entity_id": accountSelected["id"],
                                          "entity_type": accountSelected["type"]
                                        });
                                        res["content"]["error"] != null &&
                                                res["content"]["status_code"] !=
                                                    200
                                            ? _buildSnackBar(
                                                res["content"]["error"])
                                            : _buildSnackBar(
                                                "Bạn đã gửi xác minh thành công, chúng tôi sẽ xem xét và sớm gửi thông báo đến bạn!");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                )),
          )),
    );
  }

  buildSearchPageUserBottomSheet() async {
    context.loaderOverlay.show();
    await ref
        .read(pageListControllerProvider.notifier)
        .getListPageAdmin({'limit': 20});
    var userData = ref.read(meControllerProvider)[0];
    if (mounted) context.loaderOverlay.hide();
    if (mounted) {
      showCustomBottomSheet(context, MediaQuery.of(context).size.height * 0.9,
          isNoHeader: true,
          isHaveCloseButton: false,
          bgColor: Colors.grey[300], widget: StatefulBuilder(
        builder: (ctx, setStatefull) {
          final ScrollController _scrollController = ScrollController();
          searchResults = ref.watch(pageListControllerProvider).pageAdmin;

          _scrollController.addListener(() async {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              if (ref.read(pageListControllerProvider).pageAdmin.isNotEmpty &&
                  ref.read(pageListControllerProvider).isMorePageAdmin) {
                String maxId = ref
                    .read(pageListControllerProvider)
                    .pageAdmin
                    .last['score'];
                await ref
                    .read(pageListControllerProvider.notifier)
                    .getListPageAdmin({'limit': 20, 'max_id': maxId});
                setStatefull(() {});
              }
            }
          });
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tài khoản người dùng",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () async {
                    accountSelected = userData;
                    accountSelected["type"] = "Account";
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AvatarSocial(
                              width: 40,
                              height: 40,
                              //object: ref.read(meControllerProvider),
                              path: userData['avatar_media']['preview_url'] ??
                                  linkAvatarDefault),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            userData['display_name'] ?? 'Không xác định',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )),
                ),
                const Text(
                  "Danh sách Trang quản lý",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9 - 200,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          accountSelected = searchResults[index];
                          accountSelected["type"] = "Page";
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AvatarSocial(
                                    width: 40,
                                    height: 40,
                                    object: searchResults[index],
                                    path: searchResults[index] != null &&
                                            searchResults[index]
                                                    ['avatar_media'] !=
                                                null
                                        ? searchResults[index]['avatar_media']
                                            ['preview_url']
                                        : linkAvatarDefault),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  searchResults[index]?['title'] ??
                                      'Không xác định',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ));
    }
  }

  Widget criteria(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          const Icon(
            Icons.lens_rounded,
            size: 5,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget premiumExclusive(String icon, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                icon,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _buildSnackBar(String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(title),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)))),
    );
  }
}
