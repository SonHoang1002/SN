import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/page_constants.dart';
import 'package:social_network_app_mobile/providers/current_number_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreateModules/screen/request_friends_page_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_with_button_and_chip_widget.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PhonePage extends StatefulWidget {
  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  late double width = 0;
  String dropdownValue = PhonePageConstants.LIST_PHONE[0];
  final TextEditingController _codeNumberController =
      TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              SizedBox(),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Column(children: [
            Expanded(
              child: Container(
                // color: Colors.black87,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      // netwok with whatsapp....
                      Row(
                        children: [
                          Text(
                            PhonePageConstants.TITLE_PHONE[0],
                            style: const TextStyle(
                                // color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // after network account ....
                      Text(PhonePageConstants.TITLE_PHONE[1],
                          style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 15)),
                      const SizedBox(
                        height: 10,
                      ),

                      // img
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        // height: 150,
                        color: Colors.red,
                        child: Image.asset(
                          PageConstants.PATH_IMG + "phone_page_example_img.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      // to begin, we will send ....
                      Text(PhonePageConstants.TITLE_PHONE[2],
                          style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 15)),
                      const SizedBox(
                        height: 10,
                      ),
                      //input
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 80,
                                  // width: width * 0.35,
                                  child: TextFormField(
                                    controller: _codeNumberController,
                                    readOnly: true,
                                    onTap: () {
                                      _showBottomSheetForCountryCodeNumberPhone(
                                          context);
                                    },
                                    style: const TextStyle(
                                        // color: Colors.white
                                        ),
                                    decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        hintText: "CODE PHONE",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(.10)))),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 15, 25, 10),
                                    // alignment: Alignment.centerRight,
                                    height: 20,
                                    width: 20,
                                    // color: Colors.white,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      // color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Container(
                              height: 80,
                              child: TextFormField(
                                maxLength: 12,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  // CustomInputFormatter()
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: ((value) {}),
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2),
                                    ),
                                    hintText:
                                        PhonePageConstants.PLACEHOLDER_PHONE[0],
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(.10)))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(width * 0.9, 40),
                              backgroundColor:
                                  _codeNumberController.text != null
                                      ? Colors.blue
                                      : Colors.grey[800]),
                          onPressed: () {},
                          child: Text(
                            PhonePageConstants.TITLE_PHONE[3],
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            buildBottomNavigatorWithButtonAndChipWidget(
                context: context,
                width: width,
                isPassCondition: true,
                newScreen: RequestFriends(),
                title: "Tiếp",
                currentPage: 5)
          ]),
        ));
  }

  _showBottomSheetForCountryCodeNumberPhone(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: ((context) {
          return Container(
            height: 600,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Column(
              children: [
                // drag and drop navbar
                Container(
                  padding: EdgeInsets.only(top: 5),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: PhonePageConstants.LIST_PHONE.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _codeNumberController.text =
                                  PhonePageConstants.LIST_PHONE[index];
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            height: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Text(
                                      PhonePageConstants.LIST_PHONE[index],
                                      style: TextStyle(
                                        // color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                )),
                                Divider(
                                  height: 2,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
          );
        }));
  }
}
