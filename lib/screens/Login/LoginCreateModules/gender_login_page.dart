import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/general_component.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import '../widgets/have_account_widget.dart';
import 'main_login_page.dart';
import 'phone_login_page.dart';

class GenderLoginPage extends StatefulWidget {
  final dynamic data;
  const GenderLoginPage({super.key, this.data});

  @override
  State<GenderLoginPage> createState() => _GenderLoginPageState();
}

final selectionList = ["female", "male", "other"];

class _GenderLoginPageState extends State<GenderLoginPage> {
  late double width = 0;
  late double height = 0;
  String _selection = "female";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              popToPreviousScreen(context);
            },
            child: const Icon(
              FontAwesomeIcons.chevronLeft,
              size: 20,
              color: blackColor,
            )),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: SizedBox(
        height: 80,
        child: buildHaveAccountWidget(function: () {
          pushToNextScreen(context, const MainLoginPage(null));
        }),
      ),
      body: GestureDetector(
        onTap: (() {
          hiddenKeyboard(context);
        }),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            children: [
              // tiêu đề
              buildTextContent(GenderLoginConstants.GENDER_LOGIN_TITLE, true,
                  fontSize: 17, isCenterLeft: false),
              // tiêu đề con
              const SizedBox(
                height: 10.0,
              ),
              Text(
                GenderLoginConstants.GENDER_LOGIN_SUBTITLE,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              buildSpacer(height: 10),
              // lựa chọn
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                shrinkWrap: true,
                itemCount: GenderLoginConstants
                    .GENDER_LOGIN_NAME_SELECTIONS["data"].length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GeneralComponent(
                        [
                          buildTextContent(
                              GenderLoginConstants
                                      .GENDER_LOGIN_NAME_SELECTIONS["data"]
                                  [index]["title"],
                              true,
                              fontSize: 16,
                              colorWord:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                          GenderLoginConstants
                                          .GENDER_LOGIN_NAME_SELECTIONS["data"]
                                      [index]["subTitle"] !=
                                  null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: buildTextContent(
                                      GenderLoginConstants
                                              .GENDER_LOGIN_NAME_SELECTIONS[
                                          "data"][index]["subTitle"],
                                      false,
                                      fontSize: 14,
                                      colorWord: Colors.grey),
                                )
                              : const SizedBox()
                        ],
                        suffixWidget: SizedBox(
                          height: 30,
                          width: 30,
                          child: Radio(
                              value: selectionList[index],
                              groupValue: _selection,
                              fillColor: MaterialStateProperty.resolveWith(
                                  (states) => secondaryColor),
                              onChanged: (value) {
                                setState(() {
                                  _selection = value as String;
                                });
                              }),
                        ),
                        changeBackground: transparent,
                        padding: const EdgeInsets.all(5),
                        function: () {},
                      ),
                      const CrossBar(
                        height: 1,
                      )
                    ],
                  );
                },
              ),

              SizedBox(
                height: 40,
                child: ButtonPrimary(
                  label: "Tiếp tục",
                  handlePress: () {
                    pushToNextScreen(
                        context,
                        PhoneLoginPage(
                            data: {...widget.data, "gender": _selection}));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
