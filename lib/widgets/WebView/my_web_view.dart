import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/Bookmark/bookmark_page.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/screen_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String title;
  final String selectedUrl;
  final dynamic post;
  final dynamic type;

  const MyWebView(
      {super.key,
      required this.title,
      required this.selectedUrl,
      this.post,
      this.type});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController? _webViewController;

  List dropDownItems = [
    {
      'key': "popup_icons",
      "icons": [
        {
          "key": "reload",
          "icon": 'assets/icons/reload_icon.png',
          "title": "Tải lại"
        },
        {
          "key": "share",
          "icon": "assets/icons/share_icon.png",
          "title": "Chia sẻ"
        },
        {"key": "save", "icon": "assets/icons/save_icon.png", "title": "Lưu"},
      ],
    },
    {
      'key': "bookmarks",
      "title": "Xem các mục đã lưu",
    },
    {
      'key': "browser",
      "title": "Mở trong trình duyệt",
    },
    {
      'key': "save_clipboard",
      "title": "Sao chép liên kết",
    },
    // {
    //   'key': "suspect",
    //   "title": "Đánh dấu là đáng ngờ",
    // },
    {'key': "setting", "title": "Cài đặt trình duyệt"},
  ];
  chooseOption(dynamic value) async {
    switch (value['key']) {
      case "reload":
        popToPreviousScreen(context);
        setState(() {
          _webViewController!.reload();
        });
        break;
      case "share":
        popToPreviousScreen(context);
        showBarModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ScreenShare(
                entityShare: widget.post ?? {},
                type: widget.type,
                entityType: 'post'));
        break;
      case "save":
        popToPreviousScreen(context);
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            builder: (context) => BookmarkPage(
                type: widget.type,
                entitySave: widget.post,
                entityType: 'Status'));
        break;
      case "bookmarks":
        // call api
        break;
      case "browser":
        if (await canLaunchUrl(Uri.parse(widget.selectedUrl))) {
          await launchUrl(Uri.parse(widget.selectedUrl));
        } else {
          return;
        }
        break;
      case "save_clipboard":
        await Clipboard.setData(ClipboardData(text: widget.selectedUrl));
        // ignore: use_build_context_synchronously
        _buildSnackBar("Sao chép thành công");
        break;
      // case "suspect":
      //   // call api
      //   break;
      case "setting":
        pushCustomCupertinoPageRoute(context, const BrowserSetting());
        break;
      default:
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackIconAppbar(),
                AppBarTitle(
                  title: widget.title,
                ),
                PopupMenuButton(
                  offset: const Offset(0, 40),
                  child: InkWell(
                      hoverColor: Colors.transparent,
                      child: Icon(
                        FontAwesomeIcons.ellipsis,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      )),
                  onSelected: (value) {
                    chooseOption(value);
                  },
                  itemBuilder: (context) {
                    return dropDownItems.map((option) {
                      return option['icons'] == null
                          ? PopupMenuItem(
                              value: option,
                              child: Text(option['title']),
                            )
                          : PopupMenuItem(
                              value: option['title'],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: option['icons'].map<Widget>((e) {
                                      return InkWell(
                                        onTap: () {
                                          chooseOption(e);
                                        },
                                        child: Image.asset(
                                          e['icon'],
                                          height: 20,
                                          color: blackColor,
                                        ),
                                      );
                                    }).toList()),
                              ),
                            );
                    }).toList();
                  },
                ),
              ],
            )),
        body: WebView(
          initialUrl: widget.selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) {
            setState(() {
              _webViewController ??= webViewController;
              _controller.complete(_webViewController);
            });
          },
        ));
  }
}

class BrowserSetting extends StatefulWidget {
  const BrowserSetting({super.key});

  @override
  State<BrowserSetting> createState() => _BrowserSettingState();
}

class _BrowserSettingState extends State<BrowserSetting> {
  ValueNotifier contactNotifier = ValueNotifier(false);
  ValueNotifier paymentNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final colorText = Theme.of(context).textTheme.bodyMedium!.color;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackIconAppbar(),
                AppBarTitle(
                  title: "Cài đặt trình duyệt",
                ),
                SizedBox()
              ],
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              buildTextContent("Dữ liệu lướt xem", true,
                  fontSize: 18, colorWord: colorText),
              buildSpacer(height: 5),
              buildTextContent(
                  "Ngắt cookie và bộ nhớ đệm của điện thoại khỏi trang web bạn truy cập khi dùng Trình duyệt di động trên Emso",
                  false,
                  fontSize: 16,
                  colorWord: greyColor),
              buildSpacer(height: 5),
              GeneralComponent(
                [
                  buildTextContent("Dữ liệu lướt xem của bạn", false,
                      fontSize: 16, colorWord: colorText),
                  buildTextContent(
                      "Xóa lần cuối vào ${DateFormat("hh:MM, dd/mm/yyyy").format(DateTime.now())}",
                      false,
                      fontSize: 16,
                      colorWord: greyColor),
                ],
                suffixWidget: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: greyColor),
                  onPressed: () {},
                  child: const Text("Ngắt"),
                ),
                changeBackground: transparent,
                padding: EdgeInsets.zero,
              ),
              buildDivider(color: greyColor, top: 5, bottom: 5),
              buildTextContent("Tự động điền", true,
                  fontSize: 18, colorWord: colorText),
              buildSpacer(height: 5),
              Wrap(
                children: [
                  buildTextContent(
                      "Thông tin liên hệ và thông tin thanh toán được dùng để nhanh chóng hoàn tất mẫu. Chúng tôi sử dụng hoạt động tự động điền nhằm cải thiện quảng cáo và các khía cạnh trong trải nghiệm của bạn trên Emso",
                      false,
                      fontSize: 16,
                      colorWord: greyColor),
                  buildTextContentButton("Tìm hiểu thêm", false,
                      fontSize: 16, colorWord: secondaryColor, function: () {}),
                ],
              ),
              buildSpacer(height: 5),
              _buildCustomGeneralComponent(
                  [
                    buildTextContent("Tự động điền mẫu liên hệ", false,
                        fontSize: 16, colorWord: colorText),
                  ],
                  CupertinoSwitch(
                      value: contactNotifier.value,
                      onChanged: (value) {
                        setState(() {
                          contactNotifier.value = value;
                        });
                      })),
              contactNotifier.value
                  ? Column(
                      children: [
                        buildSpacer(height: 3),
                        _buildCustomGeneralComponent(
                            [
                              buildTextContent("Thông tin liên hệ", false,
                                  fontSize: 16, colorWord: colorText),
                            ],
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(
                                FontAwesomeIcons.chevronRight,
                                size: 20,
                              ),
                            )),
                        buildSpacer(height: 5),
                        buildDivider(color: greyColor)
                      ],
                    )
                  : const SizedBox(),
              buildSpacer(height: 3),
              _buildCustomGeneralComponent(
                  [
                    buildTextContent("Tự động điền mẫu thanh toán", false,
                        fontSize: 16, colorWord: colorText),
                  ],
                  CupertinoSwitch(
                      value: paymentNotifier.value,
                      onChanged: (value) {
                        setState(() {
                          paymentNotifier.value = value;
                        });
                      })),
              paymentNotifier.value
                  ? Column(
                      children: [
                        buildSpacer(height: 3),
                        _buildCustomGeneralComponent(
                            [
                              buildTextContent("Thông tin thanh toán", false,
                                  fontSize: 16, colorWord: colorText),
                            ],
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(
                                FontAwesomeIcons.chevronRight,
                                size: 20,
                              ),
                            )),
                        buildSpacer(height: 5),
                        buildDivider(color: greyColor)
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ));
  }

  Widget _buildCustomGeneralComponent(
      List<Widget> widgetList, Widget suffixWidget) {
    return GeneralComponent(
      widgetList,
      suffixWidget: suffixWidget,
      changeBackground: transparent,
      padding: EdgeInsets.zero,
    );
  }
}
