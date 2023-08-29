import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/page_constants.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_button_chip.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class SettingsPage extends StatefulWidget {
  final dynamic dataCreate;
  const SettingsPage({super.key, this.dataCreate});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double width = 0;
  List<bool> listSwitch = [true, true];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: const BackIconAppbar(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Stack(alignment: Alignment.bottomCenter, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                children: [
                  Text(
                    SettingsPageConstants.TITLE_SETTINGS[0],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      'Hãy bật những tính năng này để khai thác tối đa Trang của bạn. Bạn có thể vào phần cài đặt để thay đổi bất cứ lúc nào.',
                      style: TextStyle(fontSize: 17)),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children:
                        SettingsPageConstants.COUNTER_CONTENT.map((index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width - 95,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // content title
                                      Wrap(
                                        children: [
                                          Text(
                                            SettingsPageConstants
                                                .TITLE_CONTENT[index],
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                // color:  white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      // content subtitle
                                      Text(
                                          SettingsPageConstants
                                              .SUBTITLE_CONTENT[index],
                                          style: const TextStyle(
                                              // color: Colors.grey,
                                              fontSize: 15)),
                                    ]),
                              ),
                              Switch(
                                value: listSwitch[index],
                                activeColor: secondaryColor,
                                onChanged: ((value) {
                                  setState(() {
                                    listSwitch[index] = !listSwitch[index];
                                  });
                                }),
                              ),
                            ]),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: buildBottomNavigatorWithButtonAndChipWidget(
                  context: context,
                  width: width,
                  function: () {
                    widget.dataCreate['isCreate'] = true;
                    Navigator.pushReplacementNamed(context, '/page',
                        arguments: widget.dataCreate);
                  },
                  isPassCondition: true,
                  title: "Xong",
                  currentPage: 7),
            )
          ]),
        ));
  }
}
