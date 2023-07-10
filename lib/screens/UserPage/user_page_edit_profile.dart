import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/UserPage/EditUser/edit_notice_story.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/text_action.dart';
import 'package:provider/provider.dart' as pv;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../providers/UserPage/user_information_provider.dart';
import '../../theme/theme_manager.dart';
import '../../widgets/Banner/page_edit_media_profile.dart';
import '../../widgets/Banner/page_pick_frames.dart';
import '../../widgets/Banner/page_pick_media.dart';
import '../../widgets/StoryView/story_page.dart';
import '../../widgets/chip_menu.dart';
import '../../widgets/text_description.dart';
import '../CreatePost/create_modal_base_menu.dart';
import 'EditUser/edit_user_hobby.dart';

class UserPageEditProfile extends ConsumerStatefulWidget {
  final Function onUpdate;
  const UserPageEditProfile({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  UserPageEditProfileState createState() => UserPageEditProfileState();
}

class UserPageEditProfileState extends ConsumerState<UserPageEditProfile> {
  Widget buildLine() =>
      const CrossBar(height: 0.5, margin: 15, onlyRight: 5.0, onlyLeft: 5.0);
  final descriptionTxtCtrl = TextEditingController();
  dynamic dataPage;
  File? image;

  ListTile buildListTile(
    String normalTxt,
    String boldText,
    ThemeManager theme,
    IconData iconData,
  ) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 0.0,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 0.0,
      ),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      leading: Icon(iconData, size: 18),
      title: RichText(
        text: TextSpan(
          text: '$normalTxt ',
          style: TextStyle(
            fontSize: 15,
            color: theme.isDarkMode ? Colors.white : Colors.black,
          ),
          children: [
            TextSpan(
              text: boldText,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () {
        setState(() {
          dataPage = ref.watch(meControllerProvider)[0];
        });
      });
    }
  }

  void handleSaveHobbies() {
    final newHobbies =
        ref.read(userInformationProvider).userMoreInfor['tempHobbies'];
    ref.read(userInformationProvider.notifier).updateHobbies(newHobbies);
  }

  String renderContent(dynamic data) {
    if (data['life_event']['school_type'] == "HIGH_SCHOOL") {
      if (data['life_event']['place'] != null) {
        return '${data?['life_event']?['name']} tại ${data['life_event']['place']['title']}';
      } else {
        return '${data?['life_event']?['currently'] == true ? "Đã học" : "Học"} tại ${data['life_event']['company'] ?? data['life_event']['name']}';
      }
    } else if (data['life_event']['school_type'] == "UNIVERSITY") {
      return '${data?['life_event']?['currently'] == true ? "Từng học" : "Học"} tại ${data['life_event']['company'] ?? data['life_event']['name']}';
    } else if (data['life_event']['position'] != null) {
      return '${data?['life_event']?['position']} tại ${data['life_event']['company']}';
    } else {
      return data['life_event']['company'] ?? '';
    }
  }

  Future<dynamic> showModal(BuildContext context, typePage) {
    List listMenu = [
      {
        "key": "upload",
        "label": "Tải ảnh lên",
        "icon": FontAwesomeIcons.upload,
        "isVisibled": true
      },
      {
        "key": "pick_media",
        "label": "Chọn ảnh trên Emso",
        "icon": FontAwesomeIcons.images,
        "isVisibled": true
      },
      {
        "key": "frames",
        "label": "Thêm khung",
        "icon": FontAwesomeIcons.box,
        "isVisibled": typePage == 'avatar'
      },
    ];

    void handleChooseMedia(entityType, entity) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => PageEditMediaProfile(
                  typePage: typePage,
                  entityObj: dataPage,
                  entityType: entityType,
                  handleChangeDependencies: (value) {
                    setState(() {
                      dataPage = ref.watch(meControllerProvider)[0];
                      widget.onUpdate();
                    });
                  },
                  type: 'user',
                  file: entity)));
    }

    void openEditor() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
        // ignore: use_build_context_synchronously
        await Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageEditMediaProfile(
                    typePage: typePage,
                    entityObj: dataPage,
                    entityType: 'file',
                    handleChangeDependencies: (value) {
                      setState(() {
                        dataPage = ref.watch(meControllerProvider)[0];
                        widget.onUpdate();
                      });
                    },
                    type: 'user',
                    file: File(pickedFile.path))));
      }
    }

    void handleActionMenu(key) {
      Navigator.pop(context);
      if (key == 'upload') {
        openEditor();
      } else if (key == 'pick_media') {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PagePickMedia(
                    type: 'user',
                    user: dataPage,
                    handleAction: handleChooseMedia)));
      } else if (key == 'frames') {
        showBarModalBottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            context: context,
            builder: (context) => SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: PagePickFrames(handleAction: handleChooseMedia)));
      }
    }

    return showBarModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (context) => Container(
              margin: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      listMenu.length,
                      (index) => listMenu[index]['isVisibled']
                          ? InkWell(
                              onTap: () {
                                handleActionMenu(listMenu[index]['key']);
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        listMenu[index]['icon'],
                                        size: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .color,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      listMenu[index]['label'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox()),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = pv.Provider.of<ThemeManager>(context);
    final userAbout = ref.watch(userInformationProvider).userMoreInfor;
    final userData = ref.watch(userInformationProvider).userInfor;
    final meData = ref.watch(meControllerProvider)[0];
    final lifeEvent = ref.watch(userInformationProvider).userLifeEvent;
    final generalInformation = userAbout['general_information'];
    descriptionTxtCtrl.text = generalInformation['description'].toString();
    List featureContents = ref.watch(userInformationProvider).featureContent;
    final createdDate = meData['created_at'] != null
        ? DateTime.parse(meData['created_at'])
        : null;
    final relationshipPartner = userAbout['account_relationship'];

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            // BLOCK 1: Avatar
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
                  object: dataPage,
                  path: dataPage['avatar_media']?['preview_url'] ??
                      linkAvatarDefault,
                ),
              ),
              updateProfile: () {
                showModal(context, 'avatar');
              },
            ),
            buildLine(),
            //
            // BLOCK 2: Cover Image
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
                    dataPage['banner']?['preview_url'] ?? linkBannerDefault,
                    width: size.width - 30,
                    height: (size.width - 30) * 1.8 / 3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              updateProfile: () {
                showModal(context, 'banner');
              },
            ),
            buildLine(),
            //
            // Block 3: Description
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
                          Text('Đổi tiểu sử'),
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
                                        dataPage['id'],
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
            //
            // Block 4: Detail about user (high school, university)
            BlockProfile(
              title: "Chi tiết",
              widgetChild: Container(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: lifeEvent.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              horizontalTitleGap: 0.0,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 0.0),
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              leading: const Icon(FontAwesomeIcons.briefcase,
                                  size: 18),
                              title: Text(
                                renderContent(lifeEvent[index]),
                                style: const TextStyle(fontSize: 15),
                              ),
                            );
                          }),
                    ),
                    if (generalInformation['place_live'] != null)
                      buildListTile(
                        'Sống tại',
                        '${generalInformation['place_live']['title'] ?? generalInformation['place_live']['name']}',
                        theme,
                        FontAwesomeIcons.house,
                      ),
                    if (generalInformation['hometown'] != null)
                      buildListTile(
                        'Đến từ',
                        '${generalInformation['hometown']['title'] ?? generalInformation['hometown']['name']}',
                        theme,
                        FontAwesomeIcons.locationDot,
                      ),
                    if (relationshipPartner != null &&
                        relationshipPartner['relationship_category'] != null &&
                        relationshipPartner['partner'] != null)
                      buildListTile(
                        '${relationshipPartner['relationship_category']['name']} cùng với ',
                        '${relationshipPartner['partner']['display_name']}',
                        theme,
                        FontAwesomeIcons.heart,
                      ),
                    if (generalInformation['phone_number'] != null)
                      buildListTile(
                        generalInformation['phone_number'],
                        '',
                        theme,
                        FontAwesomeIcons.phone,
                      ),
                    if (createdDate != null)
                      buildListTile(
                        'Tham gia vào',
                        '${createdDate.day} tháng ${createdDate.month} năm ${createdDate.year}',
                        theme,
                        FontAwesomeIcons.clock,
                      ),
                  ],
                ),
              ),
              updateProfile: () {},
            ),
            buildLine(),

            // Block 5: Hobbies
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
            //
            // Block 6: Noticable
            BlockProfile(
              title: "Đáng chú ý",
              widgetChild: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      featureContents.length,
                      (index) => InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  barrierColor: transparent,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return StoryPage(
                                        user: userData,
                                        story: featureContents[index]);
                                  });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: (size.width - 50) / 3,
                                  height: 2 * (size.width - 70) / 3,
                                  margin: const EdgeInsets.only(right: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: ExtendedImage.network(
                                          featureContents[index]['banner']
                                              ['preview_url'],
                                          width: size.width / 3,
                                          height: 2 * size.width / 3,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      featureContents[index]['media_count'] > 1
                                          ? Positioned(
                                              bottom: 5,
                                              left: 5,
                                              child: Text(
                                                '+ ${featureContents[index]['media_count'] - 1}',
                                                style: const TextStyle(
                                                    fontSize: 15, color: white),
                                              ))
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                SizedBox(
                                    width: (size.width - 50) / 3,
                                    child: Text(
                                      featureContents[index]['title'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ))
                              ],
                            ),
                          )),
                ),
              ),
              updateProfile: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const EditNoticeStory(),
                  ),
                );
              },
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
