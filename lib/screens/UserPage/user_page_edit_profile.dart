import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/text_action.dart';
import 'package:provider/provider.dart' as pv;
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

import '../../providers/UserPage/user_information_provider.dart';
import '../../theme/theme_manager.dart';
import '../../widgets/chip_menu.dart';
import '../../widgets/text_description.dart';
import '../CreatePost/create_modal_base_menu.dart';
import '../Notification/noti_func.dart';
import 'EditUser/edit_user_hobby.dart';

class UserPageEditProfile extends ConsumerStatefulWidget {
  final Function onUpdate;
  const UserPageEditProfile({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  UserPageEditProfileState createState() => UserPageEditProfileState();
}

class UserPageEditProfileState extends ConsumerState<UserPageEditProfile> {
  Widget buildLine() => const CrossBar(
        height: 0.5,
        margin: 15,
        onlyRight: 5.0,
        onlyLeft: 5.0,
      );
  final descriptionTxtCtrl = TextEditingController();

  handleSaveHobbies() {
    final newHobbies =
        ref.read(userInformationProvider).userMoreInfor['tempHobbies'];
    ref.read(userInformationProvider.notifier).updateHobbies(newHobbies);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var meData = ref.watch(meControllerProvider)[0];
    final theme = pv.Provider.of<ThemeManager>(context);
    var userAbout = ref.watch(userInformationProvider).userMoreInfor;
    var lifeEvent = ref.watch(userInformationProvider).userLifeEvent;
    descriptionTxtCtrl.text =
        userAbout['general_information']['description'].toString();

    print('length: ${lifeEvent.length}');

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            BlockProfile(
              title: "Ảnh đại diện",
              widgetChild: Container(
                width: 151,
                height: 151,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.1, color: greyColor),
                ),
                child: AvatarSocial(
                  width: 150,
                  height: 150,
                  object: meData,
                  path: meData['avatar_media']?['preview_url'] ??
                      linkAvatarDefault,
                ),
              ),
              updateProfile: () {},
            ),
            buildLine(),
            BlockProfile(
              title: "Ảnh bìa",
              widgetChild: Container(
                width: size.width - 30 + 1,
                height: (size.width - 30) * 1.8 / 3 + 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(width: 0.1, color: greyColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: ExtendedImage.network(
                    meData['banner']?['preview_url'] ?? linkBannerDefault,
                    width: size.width - 30,
                    height: (size.width - 30) * 1.8 / 3,
                  ),
                ),
              ),
              updateProfile: () {},
            ),
            buildLine(),
            BlockProfile(
              title: "Tiểu sử",
              widgetChild: Text(
                '${userAbout['general_information']['description']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: greyColor),
              ),
              updateProfile: () {
                showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Column(
                        children: [
                          Text('Đổi tên bộ sưu tập'),
                          TextDescription(description: "Nhập tiểu sử mới"),
                        ],
                      ),
                      content: Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: CupertinoTextField(
                          controller: descriptionTxtCtrl,
                          autofocus: true,
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Hủy'),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: descriptionTxtCtrl.text
                                  .split('')
                                  .isNotEmpty
                              ? () {
                                  ref
                                      .read(userInformationProvider.notifier)
                                      .updateDescription(
                                        meData['id'],
                                        descriptionTxtCtrl.text.trim(),
                                      );
                                  Navigator.pop(context);
                                  widget.onUpdate();
                                  setState(() {});
                                }
                              : null,
                          child: const Text('Đổi tên'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            buildLine(),
            BlockProfile(
              title: "Chi tiết",
              widgetChild: SingleChildScrollView(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: lifeEvent.length,
                  itemBuilder: (context, index) {
                    print('$index: ${lifeEvent[index]}');
                    if (lifeEvent[index]['life_event']['visibility'] !=
                            'private' &&
                        lifeEvent[index]['life_event']['company'] != null) {
                      return ListTile(
                        // minLeadingWidth: 20,
                        dense: true,
                        horizontalTitleGap: 0.0,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        leading:
                            const Icon(FontAwesomeIcons.briefcase, size: 18),
                        title: Text(
                          renderContent(lifeEvent[index], ref),
                          style: const TextStyle(fontSize: 15),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              updateProfile: () {},
            ),
            buildLine(),
            BlockProfile(
              title: "Sở thích",
              widgetChild: Wrap(
                runSpacing: 10.0,
                children: userAbout['hobbies']
                    .map<Widget>(
                      (e) => ChipMenu(
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
                    )
                    .toList(),
              ),
              updateProfile: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreateModalBaseMenu(
                      title: "Chỉnh sửa sở thích",
                      body: const EditUserHobby(),
                      buttonAppbar: TextButton(
                        onPressed: () {
                          handleSaveHobbies();
                          Navigator.pop(context);
                          widget.onUpdate();
                          setState(() {});
                        },
                        child: Text(
                          "Lưu",
                          style: TextStyle(
                            fontSize: 18.0,
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            buildLine(),
            BlockProfile(
              title: "Đáng chú ý",
              widgetChild: Text(
                '${userAbout['general_information']['description']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: greyColor),
              ),
              updateProfile: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class BlockProfile extends StatelessWidget {
  final String title;
  final Widget widgetChild;
  final Function updateProfile;

  const BlockProfile({
    super.key,
    required this.title,
    required this.widgetChild,
    required this.updateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            TextAction(
              action: () {
                updateProfile();
              },
              fontSize: 17,
              title: 'Chỉnh sửa',
            )
          ],
        ),
        const SizedBox(height: 12.0),
        widgetChild,
        const SizedBox()
      ],
    );
  }
}
