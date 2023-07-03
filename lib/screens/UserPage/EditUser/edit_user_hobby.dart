import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import '../../../providers/UserPage/user_information_provider.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme_manager.dart';
import '../../../widgets/chip_menu.dart';
import '../../../widgets/search_input.dart';

class EditUserHobby extends ConsumerStatefulWidget {
  const EditUserHobby({super.key});

  @override
  EditUserHobbyState createState() => EditUserHobbyState();
}

class EditUserHobbyState extends ConsumerState<EditUserHobby> {
  List hobbies = [];
  List searchResult = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      hobbies = ref.read(userInformationProvider).userMoreInfor['hobbies'];
    });
  }

  TextStyle buildBoldTxtStl(ThemeManager theme) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15.5,
      color: theme.isDarkMode ? Colors.white : Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(7.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(7.5),
              child: SearchInput(
                handleSearch: (String text) async {
                  if (text != '') {
                    setState(() {
                      isLoading = true;
                    });
                    final res =
                        await UserPageApi().getHobbiesByCategories(text);
                    setState(() {
                      searchResult = res;
                      isLoading = false;
                    });
                  } else {
                    setState(() {
                      searchResult = [];
                    });
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, left: 7.5, bottom: 15.0),
              child: Text("Đã gắn thẻ", style: buildBoldTxtStl(theme)),
            ),
            Wrap(
              runSpacing: 10.0,
              children: hobbies
                  .map<Widget>(
                    (e) => Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ChipMenu(
                          isSelected: false,
                          label: e['text'],
                          icon: e['icon'] != null
                              ? ExtendedImage.network(
                                  e['icon'],
                                  width: 20.0,
                                  height: 20.0,
                                )
                              : Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.circleUser,
                                    size: 20.0,
                                    color: greyColor,
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            final newHobbies = hobbies
                                .where((h) => h['id'] != e['id'])
                                .toList();
                            setState(() {
                              hobbies = newHobbies;
                              ref
                                  .read(userInformationProvider.notifier)
                                  .saveHobbiesTemporarily(newHobbies);
                            });
                          },
                          child: Container(
                            height: 15.0,
                            width: 15.0,
                            decoration: BoxDecoration(
                              color: theme.isDarkMode
                                  ? Colors.white54
                                  : Colors.black54,
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: Icon(
                              FontAwesomeIcons.xmark,
                              color: theme.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25.0, left: 7.5, bottom: 25.0),
              child: Text("Kết quả tìm kiếm", style: buildBoldTxtStl(theme)),
            ),
            isLoading
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                    ),
                  )
                : searchResult.isEmpty
                    ? Center(
                        child: Text(
                          "Không tìm thấy sở thích nào",
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      )
                    : Wrap(
                        runSpacing: 10.0,
                        children: searchResult
                            .map<Widget>(
                              (e) => InkWell(
                                onTap: () {
                                  setState(() {
                                    if (hobbies
                                        .where((h) => h['id'] == e['id'])
                                        .isEmpty) {
                                      hobbies = [...hobbies, e];
                                      ref
                                          .read(
                                              userInformationProvider.notifier)
                                          .saveHobbiesTemporarily(hobbies);
                                    }
                                  });
                                },
                                child: ChipMenu(
                                  isSelected: false,
                                  label: e['text'],
                                  icon: e['icon'] != null
                                      ? ExtendedImage.network(
                                          e['icon'],
                                          width: 20.0,
                                          height: 20.0,
                                        )
                                      : Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: const Icon(
                                            FontAwesomeIcons.circleUser,
                                            size: 20.0,
                                            color: greyColor,
                                          ),
                                        ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
          ],
        ),
      ),
    );
  }
}
