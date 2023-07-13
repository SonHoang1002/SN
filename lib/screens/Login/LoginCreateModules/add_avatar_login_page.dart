import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/main_login_page.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';

import '../../../constant/common.dart';
import '../../../constant/login_constants.dart';
import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import '../../../widgets/Market/image_cache.dart';
import '../../../widgets/button_primary.dart';

class AddAvatarLoginPage extends StatefulWidget {
  const AddAvatarLoginPage({super.key});

  @override
  State<AddAvatarLoginPage> createState() => _AddAvatarLoginPageState();
}

class _AddAvatarLoginPageState extends State<AddAvatarLoginPage> {
  XFile? _pickedImage;

  handleGetImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
    popToPreviousScreen(context);
  }

  showImageCupertinoDialog() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            // title: buildTextContent(
            //     "Chọn ", false,
            //     fontSize: 18, isCenterLeft: false),
            actions: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Flex(direction: Axis.vertical, children: [
                  Flexible(
                    child: CupertinoButton(
                        color: Theme.of(context).canvasColor,
                        onPressed: () {
                          handleGetImage(ImageSource.camera);
                        },
                        child: buildTextContent(
                          "Ảnh từ Camera",
                          false,
                          fontSize: 16,
                          isCenterLeft: false,
                          colorWord:
                              Theme.of(context).textTheme.bodyLarge!.color,
                        )),
                  ),
                  buildDivider(color: greyColor),
                  Flexible(
                    child: CupertinoButton(
                        color: Theme.of(context).canvasColor,
                        onPressed: () {
                          handleGetImage(ImageSource.gallery);
                        },
                        child: buildTextContent(
                          "Ảnh từ thư viện",
                          false,
                          fontSize: 16,
                          isCenterLeft: false,
                          colorWord:
                              Theme.of(context).textTheme.bodyLarge!.color,
                        )),
                  ),
                ]),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height - 120,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTextContent(
                    AddAvatarLoginConstants.ADD_AVATAR_LOGIN_TITLE,
                    true,
                    fontSize: 25,
                    colorWord: Theme.of(context).textTheme.bodyLarge?.color,
                    isCenterLeft: false,
                  ),
                  buildSpacer(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: buildTextContent(
                      AddAvatarLoginConstants.ADD_AVATAR_LOGIN_SUB,
                      false,
                      fontSize: 16,
                      colorWord: Colors.grey,
                      isCenterLeft: false,
                    ),
                  ),
                  buildSpacer(height: 30),
                  Container(
                    height: 180,
                    width: 180,
                    margin: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.2, color: greyColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: _pickedImage != null
                          ? Image.file(
                              File(_pickedImage!.path),
                              width: 99.8,
                              height: 99.8,
                              fit: BoxFit.cover,
                            )
                          : ImageCacheRender(
                              path: linkAvatarDefault,
                              width: 99.8,
                              height: 99.8,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: ButtonPrimary(
                      colorButton: greyColor,
                      fontSize: 18,
                      label: "Thêm ảnh",
                      handlePress: () {
                        showImageCupertinoDialog();
                      },
                    ),
                  ),
                  buildSpacer(height: 20),
                  ButtonPrimary(
                    colorBorder: _pickedImage != null ? null : Colors.grey,
                    colorButton:
                        _pickedImage == null ? Colors.white : secondaryColor,
                    fontSize: 18,
                    label: _pickedImage != null ? "Hoàn thành" : "Bỏ qua",
                    colorText: _pickedImage == null ? Colors.grey[700] : white,
                    handlePress: () {
                      pushAndReplaceToNextScreen(
                          context, const MainLoginPage(null));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
