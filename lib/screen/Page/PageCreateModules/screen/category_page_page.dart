import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/page_constants.dart';
import 'package:social_network_app_mobile/providers/current_number_page.dart';
import 'package:social_network_app_mobile/providers/page/category_bloc.dart';
import 'package:social_network_app_mobile/providers/search_category_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreateModules/screen/information_page_page.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import '../../../../widget/GeneralWidget/bottom_navigator_with_button_and_chip_widget.dart';
import '../../../Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/how_people_can_find_you_on_facebook_modules/how_people_can_find_you_on_facebook_commons.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late double width = 0;
  late double height = 0;
  late TextEditingController _categoryController =
      TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: height * 0.78055,
                  // color: Colors.black87,
                  child: ListView(
                    children: [
                      Container(
                          // color: Colors.black87,
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(children: [
                                //question
                                Wrap(
                                  children: [
                                    Text(
                                      CategoryPageConstants.QUESTION_NAME[0],
                                      style: const TextStyle(
                                          // color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // description for question
                                Text(CategoryPageConstants.QUESTION_NAME[1],
                                    style: const TextStyle(
                                        // color: Colors.white,
                                        fontSize: 20)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    border: Border.all(color: Colors.black),
                                    // color: Colors.red
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 10,
                                        child: Column(
                                          children: [
                                            Wrap(
                                                direction: Axis.horizontal,
                                                children: Provider.of<
                                                            CategoryProvider>(
                                                        context)
                                                    .model
                                                    .listCate
                                                    .map((valueOfCategory) {
                                                  return selectedArea(context,
                                                      true, valueOfCategory);
                                                }).toList()),
                                            Provider.of<CategoryProvider>(
                                                            context)
                                                        .model
                                                        .listCate
                                                        .length >
                                                    2
                                                ? Container()
                                                : TextFormField(
                                                    style: TextStyle(
                                                        // color: Colors.white
                                                        ),
                                                    controller:
                                                        _categoryController,
                                                    onChanged: (value) {
                                                      context
                                                          .read<
                                                              SearchCategoryProvider>()
                                                          .setSearchCategoryProvider(
                                                              (value));
                                                      setState(() {});
                                                    },
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            CategoryPageConstants
                                                                .PLACEHOLDER_CATEGORY,
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 10)),
                                                  )
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                          child: Icon(
                                        Icons.search,
                                        // color: Colors.white,
                                      )),
                                    ],
                                  ),
                                ),
                                _categoryController.text.trim().length > 0
                                    ? Container(
                                        height: 200,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return suggestComponent(Provider.of<
                                                        SearchCategoryProvider>(
                                                    context)
                                                .searchList[index]);
                                          },
                                          itemCount: Provider.of<
                                                      SearchCategoryProvider>(
                                                  context,
                                                  listen: false)
                                              .searchList
                                              .length,
                                        ),
                                      )
                                    : Container(),
                                // hang muc pho bien
                                Container(
                                  padding: EdgeInsets.only(left: 10, top: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        CategoryPageConstants.TITLE,
                                        style: TextStyle(
                                            // color: Colors.white,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                selectedArea(context, false,
                                    CategoryPageConstants.POPULAR_CATEGORY[0]),
                                selectedArea(context, false,
                                    CategoryPageConstants.POPULAR_CATEGORY[1]),
                                selectedArea(context, false,
                                    CategoryPageConstants.POPULAR_CATEGORY[2]),
                                selectedArea(context, false,
                                    CategoryPageConstants.POPULAR_CATEGORY[3]),
                              ]))),
                    ],
                  ),
                ),
                buildBottomNavigatorWithButtonAndChipWidget(
                    context: context,
                    width: width,
                    isPassCondition: true,
                    newScreen: InformationPagePage(),
                    title: "Tiếp",
                    currentPage: 2)
              ]),
        ));
  }

  Widget selectedArea(BuildContext context, bool hasIcon, String value) {
    return GestureDetector(
      onTap: (() {
        if (hasIcon == false) {
          CategoryModel model =
              Provider.of<CategoryProvider>(context, listen: false).model;
          bool hasValue = false;
          for (int i = 0; i < model.listCate.length; i++) {
            if (model.listCate[i].contains(value)) {
              hasValue = true;
            }
          }
          if (hasValue) {
            showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: Text(CategoryPageConstants.WARNING_MESSAGE[0]),
                    actions: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  );
                }));
          } else {
            if (model.listCate.length > 2) {
              showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      title: Text(CategoryPageConstants.WARNING_MESSAGE[1]),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    );
                  }));
            } else {
              Provider.of<CategoryProvider>(context, listen: false)
                  .setAddCategoryProvider(value);
              setState(() {});
            }
          }
        }
      }),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.grey[700]
                ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                hasIcon
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: (() {
                              Provider.of<CategoryProvider>(context,
                                      listen: false)
                                  .setDeleteCategoryProvider(value);
                              setState(() {});
                            }),
                            child: Container(
                              height: 18,
                              width: 18,
                              child: Center(
                                  child: Icon(
                                Icons.close_outlined,
                                size: 13,
                              )),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      )
                    : Container(),
                Text(
                  value,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget suggestComponent(String value) {
    return GestureDetector(
      onTap: (() {
        CategoryModel model =
            Provider.of<CategoryProvider>(context, listen: false).model;
        if (model.listCate.length < 4) {
          bool hasValue = false;
          for (int i = 0; i < model.listCate.length; i++) {
            if (model.listCate[i].contains(value)) {
              hasValue = true;
            }
          }
          if (hasValue) {
            showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: Text(CategoryPageConstants.WARNING_MESSAGE[0]),
                  );
                }));
          } else {
            Provider.of<CategoryProvider>(context, listen: false)
                .setAddCategoryProvider(value);
            _categoryController.text = "";
            setState(() {});
          }
        }
      }),
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
                  value,
                  style: TextStyle(
                    color: Colors.white,
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
  }
}
