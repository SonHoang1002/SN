import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../apis/user_page_api.dart';
import '../../../../providers/UserPage/user_information_provider.dart';
import '../../../../providers/me_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/theme_manager.dart';
import '../../../../widgets/appbar_title.dart';
import '../../../../widgets/back_icon_appbar.dart';
import '../../../../widgets/button_primary.dart';
import 'package:provider/provider.dart' as pv;

import '../../../../widgets/search_input.dart';

class ChangeLivingPlace extends ConsumerStatefulWidget {
  final bool? city;
  const ChangeLivingPlace({Key? key, this.city}): super(key: key);

  @override
  ChangeLivingPlaceState createState() => ChangeLivingPlaceState();
}

class ChangeLivingPlaceState extends ConsumerState<ChangeLivingPlace> {
  bool isLoading = false;
  bool isSaving = false;
  List searchResult = [];
  String resultPlace = '';
  String newPlaceId = '';

  Text buildBoldTxt(String title, ThemeManager theme) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: theme.isDarkMode ? Colors.white : Colors.black,
        fontSize: 17.0,
      ),
    );
  }

  Widget buildDrawer() {
    return Container(
      height: 0.75,
      color: greyColor[300],
      margin: const EdgeInsets.symmetric(vertical: 17.5),
    );
  }

  Future<bool> handleSaveLivingPlace() async {
    final userAbout = ref.watch(userInformationProvider).userMoreInfor;
    final infor = userAbout?['general_information'];
    final payload = {
      "account_display_fields": infor['account_display_fields'],
      "account_social": infor['account_social'],
      "account_web_link": infor['account_web_link'],
      "address":infor['address'],
      "birth_date": infor['birth_date'],
      "birth_month": infor['birth_month'],
      "birth_year": infor['birth_year'],
      "gender": infor['gender'],
      "other_name": infor['other_name'],
      "phone_number": infor['phone_number'],
      if (widget.city==null)
        "place_live_id":newPlaceId
      else
        "hometown_id":newPlaceId
      };

    final userId = ref.read(meControllerProvider)[0]['id'];
    final res = await UserPageApi().updateOtherInformation(userId, payload);
    await ref
        .read(userInformationProvider.notifier)
        .getUserMoreInformation(userId);
    if (res != null && mounted) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildNormalTxt(String title, ThemeManager theme) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w200,
          color: theme.isDarkMode ? Colors.white70 : Colors.black87,
          fontSize: 14.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = pv.Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: "Chỉnh sửa nơi sống"),
            ButtonPrimary(
              label: isSaving ? "" : "Lưu",
              icon: isSaving
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : null,
              handlePress: () async {
                setState(() {
                  isSaving = true;
                });
                final result = await handleSaveLivingPlace();
                setState(() {
                  isSaving = false;
                });
                if (result) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        margin: const EdgeInsets.symmetric(horizontal: 12.5),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchInput(
                handleSearch: (String text) async {
                  if (text != '') {
                    setState(() {
                      isLoading = true;
                    });
                    final res =
                        await UserPageApi().getLivingPlaceByKeyword(text);
                    setState(() {
                      searchResult = res;
                      isLoading = false;
                    });
                  } else {
                    setState(() {
                      searchResult = [];
                      resultPlace = '';
                    });
                  }
                },
              ),
              const SizedBox(height: 25.0),
              resultPlace != ''
                  ? buildBoldTxt('Thông tin hiển thị ', theme)
                  : const SizedBox(),
              resultPlace != ''
                  ? buildNormalTxt('Sống tại $resultPlace', theme)
                  : const SizedBox(),
              resultPlace != '' ? buildDrawer() : const SizedBox(),
              isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                    ))
                  : searchResult.isEmpty
                      ? const Center(child: Text('Không có kết quả tìm kiếm'))
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: searchResult.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              var item = searchResult[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    resultPlace = item['title'];
                                    newPlaceId = item['id'];
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 7.5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5,
                                        color: theme.isDarkMode
                                            ? Colors.white70
                                            : Colors.black87),
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                  height: 50.0,
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 20.0, color: Colors.red[400]),
                                      const SizedBox(width: 20.0),
                                      SizedBox(
                                        width: 290,
                                        child: Text(
                                          item['title'],
                                          style: TextStyle(
                                            color: theme.isDarkMode
                                                ? Colors.white70
                                                : Colors.black87,
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
