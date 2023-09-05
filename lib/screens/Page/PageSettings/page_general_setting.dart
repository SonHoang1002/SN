import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';

import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/page/page_settings_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

class PageGeneralSettings extends ConsumerStatefulWidget {
  final dynamic data;
  final bool? rolePage;
  final Function? handleChangeDependencies;
  const PageGeneralSettings(
      {Key? key, this.data, this.rolePage, this.handleChangeDependencies})
      : super(key: key);

  @override
  ConsumerState<PageGeneralSettings> createState() =>
      _PageGeneralSettingsState();
}

class _PageGeneralSettingsState extends ConsumerState<PageGeneralSettings> {
  PageSettingsState pSettings = PageSettingsState();
  FocusNode focus = FocusNode();
  TextEditingController _controller = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  List monitored_keywords = [];
  Map<String, String> filterUserList = {
    'public': 'Bất kỳ người dùng nào',
    'over17': 'Người dùng trên 17 tuổi',
    'over18': 'Người dùng trên 18 tuổi',
    'over21': 'Người dùng trên 21 tuổi',
  };
  dynamic _filterSelection;

  Future<void> getSettings() async {
    setData();
    var response = await PageApi().getSettingsPage(widget.data["id"]) ?? [];
    var pSettings = PageSettingsState(
        visitor_posts: response["visitor_posts"] ?? "",
        age_restrictions: response["age_restrictions"],
        cencored: widget.data["monitored_keywords"]);
    ref.read(pageSettingsControllerProvider.notifier).updateState(pSettings);
    setState(() {
      setData();
    });
  }

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  void setData() {
    pSettings = ref.read(pageSettingsControllerProvider);
    _filterSelection = pSettings.age_restrictions;
    _controller =
        TextEditingController(text: filterUserList[pSettings.age_restrictions]);
    monitored_keywords = List.from(pSettings.cencored);
  }

  @override
  void dispose() {
    focus.dispose();
    _controller.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CupertinoActivityIndicator(),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Chung'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quản lý nội dung trên trang",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  /*  const Text(
                    "Giới hạn người dùng đăng bài",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                    child: TextFormField(
                      enabled: false,
                      autofocus: false,
                      decoration: const InputDecoration(
                        /* fillColor: greyColorOutlined,
                        filled: true, */
                        border: OutlineInputBorder(),
                        labelText: 'Không cho phép đăng bài',
                      ),
                    ),
                  ), */
                  const Text(
                    "Giới hạn người dùng đăng bài",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      buildFilterUsersSelectionBottomSheet();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: TextFormField(
                        controller: _controller,
                        enabled: false,
                        autofocus: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Giới hạn độ tuổi',
                        ),
                      ),
                    ),
                  ),
                  Text(
                      "Khi giới hạn tuổi cho Trang của bạn, những người có tuổi bé hơn sẽ không thể xem được Trang hoặc nội dung Trang của bạn"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 6),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: focus.hasFocus ? secondaryColor : greyColor,
                            width: focus.hasFocus ? 2 : 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Wrap(
                              children: List.generate(monitored_keywords.length,
                                  (index) => selectedArea(context, index))),
                        ),
                        TextFormField(
                          focusNode: focus,
                          controller: _categoryController,
                          onEditingComplete: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            monitored_keywords = [
                              ...monitored_keywords,
                              _categoryController.text
                            ];
                            setState(() {
                              _categoryController.text = "";
                            });
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search),
                              labelText: "Thêm từ, cụm từ cần kiểm duyệt",
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 12, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /* const Divider(
                          height: 20,
                          thickness: 1,
                        ), */
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ButtonPrimary(
                                  label: 'Lưu thay đổi',
                                  handlePress: () async {
                                    context.loaderOverlay.show();
                                    var res = await PageApi().pagePostMedia(
                                      {
                                        "monitored_keywords":
                                            monitored_keywords,
                                      },
                                      widget.data['id'],
                                    );
                                    await PageApi()
                                        .updateSettingsPage(widget.data['id'], {
                                      "age_restrictions":
                                          pSettings.age_restrictions,
                                    });
                                    if (mounted) {
                                      context.loaderOverlay.hide();
                                      if (res != null) {
                                        pSettings.cencored = monitored_keywords;
                                        ref
                                            .read(pageSettingsControllerProvider
                                                .notifier)
                                            .updateState(pSettings);
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                          'Có lỗi sảy ra , xin vui lòng thử lại sau',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )));
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ButtonPrimary(
                                  label: 'Đặt lại',
                                  isGrey: true,
                                  handlePress: () {
                                    setState(() {
                                      monitored_keywords = [];
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /* const Text(
                    "Gỡ trang",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Khi nhấp vào xóa, Trang của bạn sẽ bị xóa vĩnh viễn. Sau khi xóa vĩnh viễn, tất cả các dữ liệu của Trang sẽ bị xóa và không thể khôi phục lại.",
                    ),
                  ),
                  ButtonPrimary(
                    label: 'Xoá Trang ${widget.data['title']}',
                    isGrey: true,
                    handlePress: () {
                      setState(() {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => CupertinoAlertDialog(
                            title: const Text('Gỡ Trang'),
                            content: const Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    'Bạn có chắc chắn muốn xóa vĩnh viễn Trang này? Tất cả dữ liệu sẽ bị xóa và không thể khôi phục sau khi bạn xác nhận Gỡ Trang',
                                    style: TextStyle(
                                        fontSize: 13, color: greyColor)),
                              ],
                            ),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Huỷ'),
                              ),
                              CupertinoDialogAction(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child: const Text('Gỡ Trang vĩnh viễn'),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ), */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectedArea(BuildContext context, dynamic value) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.grey),
      child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            InkWell(
              onTap: (() {}),
              child: Text(
                monitored_keywords[value],
                style: const TextStyle(
                    color: white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  monitored_keywords.remove(monitored_keywords[value]);
                });
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

  buildFilterUsersSelectionBottomSheet() {
    showCustomBottomSheet(context, 300,
        title: "Giới hạn độ tuổi",
        isHaveCloseButton: false,
        bgColor: Colors.grey[300], widget: StatefulBuilder(
      builder: (ctx, setStatefull) {
        return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: filterUserList.length,
            itemBuilder: (context, index) {
              String key = filterUserList.keys.elementAt(index);
              String value = filterUserList[key] ?? '';
              return InkWell(
                child: Column(
                  children: [
                    GeneralComponent(
                      [
                        buildTextContent(value, true),
                      ],
                      changeBackground: transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      suffixWidget: Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => secondaryColor),
                        groupValue: _filterSelection,
                        value: key,
                        onChanged: (value) async {
                          setState(() {
                            _filterSelection = key;
                          });
                          popToPreviousScreen(context);
                        },
                      ),
                      function: () async {
                        setState(() {
                          _filterSelection = key;
                          _controller.text = value;
                          pSettings.age_restrictions = key;
                        });
                        popToPreviousScreen(context);
                      },
                    ),
                    buildSpacer(height: 10)
                  ],
                ),
              );
            });
      },
    ));
  }
}
