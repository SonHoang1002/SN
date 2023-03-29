import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/providers/page/search_category_provider.dart';
import '../../../../constant/page_constants.dart';
import '../../../../providers/page/category_provider.dart';

import 'information_page_page.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/back_icon_appbar.dart';

import '../../../../widget/GeneralWidget/bottom_navigator_button_chip.dart';

class CategoryPage extends StatefulWidget {
  final dataCreate;
  const CategoryPage({super.key, this.dataCreate});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late double width = 0;
  late double height = 0;
  final TextEditingController _categoryController = TextEditingController();
  List categorySelected = [];
  FocusNode focus = FocusNode();

  @override
  void dispose() {
    focus.dispose();
    _categoryController.dispose();
    super.dispose();
  }

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
                SizedBox(
                  height: height * 0.78055,
                  width: size.width - 18,
                  child: ListView(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(children: [
                            //question
                            Wrap(
                              children: [
                                Text(
                                  'Hạng mục nào mô tả chính xác nhất về ${widget.dataCreate['title']}?',
                                  style: const TextStyle(
                                      // color:  white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // description for question
                            const Text(
                                'Nhờ hạng mục, mọi người sẽ tìm thấy Trang này trong kết quả tìm kiếm. Bạn có thể thêm đến 3 hạng mục.',
                                style: TextStyle(
                                    // color:  white,
                                    fontSize: 16)),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 3, 0, 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: focus.hasFocus
                                          ? secondaryColor
                                          : greyColor,
                                      width: focus.hasFocus ? 2 : 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Column(
                                children: [
                                  if (categorySelected.isNotEmpty)
                                    Container(
                                      width: width,
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: Wrap(
                                          children: List.generate(
                                              categorySelected.length,
                                              (index) => selectedArea(context,
                                                  categorySelected[index]))),
                                    ),
                                  if (categorySelected.length < 3)
                                    TextFormField(
                                      focusNode: focus,
                                      controller: _categoryController,
                                      onChanged: (value) {
                                        context
                                            .read<SearchCategoryProvider>()
                                            .setSearchCategoryProvider(
                                                value, categorySelected);
                                        setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          suffixIcon: Icon(Icons.search),
                                          hintText: CategoryPageConstants
                                              .PLACEHOLDER_CATEGORY,
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 20),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10, 12, 0, 0)),
                                    ),
                                ],
                              ),
                            ),
                            _categoryController.text.trim().isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: greyColor,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    height: 238,
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        return suggestComponent(
                                            Provider.of<SearchCategoryProvider>(
                                                    context)
                                                .searchList[index]);
                                      },
                                      itemCount:
                                          Provider.of<SearchCategoryProvider>(
                                                  context,
                                                  listen: false)
                                              .searchList
                                              .length,
                                    ),
                                  )
                                : Container(),
                            // hang muc pho bien
                            if (categorySelected.length < 3)
                              Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                child: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const Text(
                                      CategoryPageConstants.TITLE,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            if (categorySelected.length < 3)
                              SizedBox(
                                width: width,
                                child: Wrap(
                                    children: List.generate(
                                        CategoryPageConstants
                                            .POPULAR_CATEGORY.length,
                                        (index) => selectedArea(
                                            context,
                                            CategoryPageConstants
                                                .POPULAR_CATEGORY[index]))),
                              ),
                          ])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: buildBottomNavigatorWithButtonAndChipWidget(
                      context: context,
                      width: width,
                      isPassCondition: categorySelected.isNotEmpty,
                      newScreen: InformationPagePage(),
                      title: "Tiếp",
                      currentPage: 2),
                )
              ]),
        ));
  }

  Widget selectedArea(BuildContext context, String value) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.grey),
      child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            InkWell(
              onTap: (() {
                print(1);
                if (categorySelected.contains(value)) {
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
                                child: const Text(
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
                  setState(() {
                    categorySelected.add(value);
                  });
                }
              }),
              child: Text(
                value,
                style: const TextStyle(
                    color: white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: () {
                if (mounted) {
                  setState(() {
                    List tempCategory = categorySelected;
                    categorySelected = tempCategory
                        .where(
                          (e) => e != value,
                        )
                        .toList();
                  });
                  focus.requestFocus();
                }
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8, 3, 5, 3),
                child: Icon(
                  FontAwesomeIcons.solidCircleXmark,
                  size: 16,
                  color: white,
                ),
              ),
            )
          ]),
    );
  }

  Widget suggestComponent(String value) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          categorySelected.add(value);
          _categoryController.text = '';
        });
      }),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: greyColor.withOpacity(0.6)))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
