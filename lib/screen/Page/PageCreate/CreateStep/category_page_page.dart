import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreate/CreateStep/information_page_page.dart';

import '../../../../constant/page_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/bottom_navigator_button_chip.dart';
import '../../../../widget/back_icon_appbar.dart';

class CategoryPage extends StatefulWidget {
  final dynamic dataCreate;
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
  List categorySearch = [];

  List categoryPopular = CategoryPageConstants.POPULAR_CATEGORY;
  bool loadingCreate = false;
  @override
  void dispose() {
    focus.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future handleSearch(value) async {
    var response = await PageApi().searchCategoryPage({'keyword': value});
    if (response != null) {
      if (!mounted) return;
      setState(() {
        categorySearch = response.toList();
      });
    }
  }

  Future handleCreatePage(data) async {
    var response = await PageApi().createPage(data);

    if (!mounted) return;
    setState(() {
      loadingCreate = false;
    });
    if (response.statusCode == 200) {
      pushToNextScreen(
          context,
          InformationPagePage(dataCreate: {
            ...widget.dataCreate,
            'category': categorySelected,
            ...jsonDecode(response.body)
          }));
    } else {
      _showAlertDialog(
          context, 'Tạo trang không thành công, vui lòng thử lại!');
    }
  }

  void _showAlertDialog(BuildContext context, String errorLogin) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Thất bại'),
              content: Text(errorLogin),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Đồng ý'),
                ),
              ],
            ));
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
                            const Text(
                                'Nhờ hạng mục, mọi người sẽ tìm thấy Trang này trong kết quả tìm kiếm. Bạn có thể thêm đến 3 hạng mục.',
                                style: TextStyle(
                                    // color:  white,
                                    fontSize: 16)),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 3, 0, 6),
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
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                        handleSearch(value);
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          suffixIcon: Icon(Icons.search),
                                          labelText: CategoryPageConstants
                                              .PLACEHOLDER_CATEGORY,
                                          labelStyle: TextStyle(
                                              color: Colors.grey, fontSize: 16),
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
                                            categorySearch[index]);
                                      },
                                      itemCount: categorySearch.length,
                                    ),
                                  )
                                : Container(),
                            // hang muc pho bien
                            if (categorySelected.length < 3)
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
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
                                        categoryPopular
                                            .where((element) =>
                                                !(categorySelected
                                                    .contains(element)))
                                            .length,
                                        (index) => selectedArea(
                                            context,
                                            categoryPopular
                                                .where((element) =>
                                                    !(categorySelected
                                                        .contains(element)))
                                                .toList()[index]))),
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
                      function: () {
                        if (!mounted) return;
                        setState(() {
                          loadingCreate = true;
                        });
                        handleCreatePage({
                          ...widget.dataCreate,
                          'page_category':
                              categorySelected.map((e) => e['id']).toList()
                        });
                      },
                      loading: loadingCreate,
                      title: "Tiếp",
                      currentPage: 2),
                )
              ]),
        ));
  }

  Widget selectedArea(BuildContext context, dynamic value) {
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
                if (categorySelected
                    .map((el) => el['id'])
                    .contains(value['id'])) {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text(
                            CategoryPageConstants.WARNING_MESSAGE[0],
                            style: const TextStyle(fontSize: 17),
                          ),
                          actions: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Đồng ý",
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                          ],
                        );
                      }));
                } else {
                  if (mounted) {
                    setState(() {
                      categorySelected.add(value);
                    });
                    if (categorySelected.length < 3) {
                      focus.requestFocus();
                    }
                  }
                }
              }),
              child: Text(
                value['text'],
                style: const TextStyle(
                    color: white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: () {
                if (mounted) {
                  if (!mounted) return;
                  setState(() {
                    List tempCategory = categorySelected;
                    categorySelected = tempCategory
                        .where(
                          (e) => e['id'] != value['id'],
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

  Widget suggestComponent(dynamic value) {
    return GestureDetector(
      onTap: (() {
        if (!mounted) return;
        setState(() {
          categorySelected.add(value);
          _categoryController.text = '';
        });
      }),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: greyColor.withOpacity(0.6)))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              value?['text'] ?? '',
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
