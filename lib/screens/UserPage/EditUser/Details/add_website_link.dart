import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../../../helper/push_to_new_screen.dart';
import '../../../../providers/UserPage/user_information_provider.dart';
import '../../../../providers/me_provider.dart';
import '../../../../theme/theme_manager.dart';
import '../../../../widgets/WebView/my_web_view.dart';
import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import '../../../../widgets/button_primary.dart';
import 'package:provider/provider.dart' as pv;

class AddWebsiteLink extends ConsumerStatefulWidget {
  const AddWebsiteLink({super.key});

  @override
  AddWebsiteLinkState createState() => AddWebsiteLinkState();
}

class AddWebsiteLinkState extends ConsumerState<AddWebsiteLink> {
  List urls = [];
  String newUrl = '';
  bool createNewLink = false;
  bool isLoading = false;

  Widget buildRowInfo(String title, Function onDelete, ThemeManager theme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: greyColor[300],
        child: Icon(FontAwesomeIcons.earthAsia,
            size: 22.5,
            color: theme.isDarkMode ? Colors.white60 : Colors.black54),
      ),
      title: InkWell(
        onTap: () {
          if (title.contains('https')) {
            pushCustomCupertinoPageRoute(
              context,
              MyWebView(
                title: 'Liên kết ngoài',
                selectedUrl: title,
              ),
            );
          }
        },
        child: Text(
          title,
          style: const TextStyle(color: secondaryColor),
        ),
      ),
      subtitle: Text(
        'Trang web',
        style: TextStyle(
            color: theme.isDarkMode ? Colors.white60 : Colors.black54),
      ),
      trailing: InkWell(
        onTap: () {
          onDelete();
        },
        child: Icon(
          Icons.delete_outline,
          size: 25.0,
          color: Colors.red[300],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initWebsiteLinks();
    });
  }

  void initWebsiteLinks() {
    final infor = ref
        .watch(userInformationProvider)
        .userMoreInfor?['general_information'];
    setState(() {
      urls = infor['account_web_link'];
    });
  }

  Future<bool> addNewUrl(oldUrls, String newUrl) async {
    var resVal = false;
    final userId = ref.read(meControllerProvider)[0]['id'];
    final info = ref
        .watch(userInformationProvider)
        .userMoreInfor?['general_information'];
    final res = await UserPageApi().updateOtherInformation(userId, {
      "account_web_link": [
        {'url': newUrl},
        ...oldUrls
      ],
      "account_display_fields": info['account_display_fields'],
    });
    if (res != null) {
      resVal = true;
    }
    await ref
        .read(userInformationProvider.notifier)
        .getUserMoreInformation(userId);
    return resVal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            AppBarTitle(title: "Tạo trang web"),
            SizedBox(),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              urls.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: urls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 7.5),
                          child: buildRowInfo(urls[index]['url'], () {}, theme),
                        );
                      })
                  : const SizedBox(),
              createNewLink
                  ? Container(
                      width: size.width,
                      margin: const EdgeInsets.only(top: 12.5),
                      height: 100.0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 45.0,
                            child: CupertinoTextField(
                              style: TextStyle(color: colorWord(context)),
                              placeholder: "Nhập url trang web ...",
                              placeholderStyle:  TextStyle(
                                color: colorWord(context),
                                fontSize: 16.5,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  newUrl = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      createNewLink = false;
                                    });
                                  },
                                  child: Container(
                                    width: 70.0,
                                    padding: const EdgeInsets.all(8.5),
                                    decoration: BoxDecoration(
                                      color: greyColor[300],
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: const Center(
                                      child: Text("Hủy",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                InkWell(
                                  onTap: () async {
                                    final oldUrls = urls;
                                    setState(() {
                                      isLoading = true;
                                      urls = [
                                        ...urls,
                                        {'url': newUrl}
                                      ];
                                    });
                                    final result =
                                        await addNewUrl(oldUrls, newUrl);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (result) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Container(
                                    width: 70.0,
                                    padding: const EdgeInsets.all(8.5),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: isLoading
                                        ? const Center(
                                            child: CupertinoActivityIndicator(
                                                color: Colors.white),
                                          )
                                        : const Center(
                                            child: Text(
                                              "Thêm",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              ButtonPrimary(
                label: "Thêm trang web",
                colorButton: greyColor[300],
                colorText: Colors.black54,
                handlePress: () {
                  setState(() {
                    createNewLink = true;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
