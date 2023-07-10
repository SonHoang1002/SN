import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 120,
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
                      margin:
                          const EdgeInsets.only(bottom: 5, right: 5, left: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(width: 0.2, color: greyColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: ImageCacheRender(
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
                      height: 50,
                      child: ButtonPrimary(
                        fontSize: 18,
                        label: "Thêm ảnh",
                        handlePress: () {},
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ButtonPrimary(
                        colorBorder: Colors.grey,
                        colorButton: Colors.white,
                        fontSize: 18,
                        label: "Bỏ qua",
                        colorText: Colors.grey[700],
                        handlePress: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
