import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Page/PageEdit/page_action.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/SnackBar/custom_snackbar.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:provider/provider.dart' as pv;

class GroupMemberQuestionsSetting extends ConsumerStatefulWidget {
  final dynamic groupDetail;
  const GroupMemberQuestionsSetting({super.key, required this.groupDetail});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupMemberQuestionsSettingState();
}

class _GroupMemberQuestionsSettingState
    extends ConsumerState<GroupMemberQuestionsSetting> {
  List<dynamic> listQuestion = [];
  bool _isLoading = true;
  dynamic question1;
  dynamic question2;
  dynamic question3;
  dynamic listAns;
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    await ref
        .read(groupListControllerProvider.notifier)
        .getMemberQuestion(widget.groupDetail["id"]);
    listQuestion = ref.read(groupListControllerProvider).memberQuestionList;
    setData();
  }

  setData() {
    for (var element in listQuestion) {
      int index = listQuestion.indexOf(element);

      listAns = [];
      for (int i = 0; i < element["options"].length; i++) {
        listAns.add(element["options"][i]);
      }

      switch (index) {
        case 0:
          question1 = listAns;
          break;
        case 1:
          question2 = listAns;
          break;
        case 2:
          question3 = listAns;
          break;
        default:
          break;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  updateQuestion(params) {
    setState(() {
      _isLoading = true;
    });
    bool found = false;
    for (int i = 0; i < listQuestion.length; i++) {
      if (listQuestion[i]["id"] == params["id"]) {
        listQuestion[i] = params;
        found = true;
        break; // Thoát khỏi vòng lặp sau khi cập nhật
      }
    }
    if (found == false) {
      listQuestion.add(params);
      setData();
    }
    setState(() {
      _isLoading = false;
    });
  }

  deleteQuestion(id) async {
    setState(() {
      _isLoading = true;
    });
    await GroupApi().removeMemberQuestion(widget.groupDetail["id"], id);
    listQuestion.removeWhere((element) => element["id"] == id);
    setState(() {
      _isLoading = false;
    });
    if (mounted) CustomSnackBar.showSnackBar(context, "Xoá thành công");
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
            title: const AppBarTitle(
              title: "Câu hỏi chọn thành viên",
            ),
            leading: const BackIconAppbar(),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listQuestion.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listQuestion.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return questionContainer(index, question1);
                              } else if (index == 1) {
                                return questionContainer(index, question2);
                              } else {
                                return questionContainer(index, question3);
                              }
                            },
                          )
                        : _isLoading
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: buildCircularProgressIndicator(),
                              )
                            : const Center(
                                child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Chưa có câu hỏi nào"),
                              )),
                    listQuestion.length < 3
                        ? GestureDetector(
                            onTap: () {
                              _showBottomSheetForSelect(
                                  context, null, updateQuestion);
                            },
                            child: ButtonPrimary(
                              isGrey: _isLoading,
                              label: "Tạo câu hỏi",
                              colorText: white,
                            ),
                          )
                        : Container()
                  ],
                )),
          )),
    );
  }

  Widget questionContainer(index, question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Câu hỏi ${index + 1}. ${listQuestion[index]["question_text"]}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          listQuestion[index]["question_type"] == "checkboxes"
              ? Column(
                  children: List.generate(
                      listQuestion[index]["options"].length,
                      (indexGes) => ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 0.0),
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -1),
                            title:
                                Text(listQuestion[index]["options"][indexGes],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    )),
                            trailing: Radio(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => greyColor),
                                groupValue: question,
                                value: false,
                                onChanged: (value) {}),
                          )),
                )
              : listQuestion[index]["question_type"] == "multiple_choice"
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listQuestion[index]["options"].length,
                      shrinkWrap: true,
                      itemBuilder: (context, indexQuestion) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                listQuestion[index]["options"][indexQuestion],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 2.0, color: greyColor),
                                ),
                                value: false,
                                activeColor: secondaryColor,
                                onChanged: (value) {},
                              ),
                            ],
                          ))
                  : TextFormField(
                      enabled: false,
                      autofocus: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nhập câu trả lời',
                      ),
                      onChanged: (value) {},
                      maxLines: 1,
                    ),
          const Divider(
            height: 20,
            color: greyColor,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ButtonPrimary(
                  isGrey: true,
                  label: "Xoá",
                  handlePress: () async {
                    await showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Xóa câu hỏi'),
                        content: const Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Bạn có chắc chắn muốn xóa câu hỏi này không? Hành động này không thể hoàn tác.',
                                style:
                                    TextStyle(fontSize: 13, color: blackColor)),
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
                              deleteQuestion(listQuestion[index]["id"]);
                            },
                            child: const Text('Xác nhận'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ButtonPrimary(
                  isGrey: true,
                  label: "Chỉnh sửa",
                  handlePress: () {
                    _showBottomSheetForSelect(
                        context, listQuestion[index], updateQuestion);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showBottomSheetForSelect(
      BuildContext context, dynamic action, Function callback) {
    double screenHeight = MediaQuery.of(context).size.height;
    double contentHeight = screenHeight - AppBar().preferredSize.height;
    showModalBottomSheet(
        backgroundColor: transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: contentHeight,
            child: FractionallySizedBox(
                heightFactor: 1,
                child: _AddQuestion(
                  action: action,
                  groupDetail: widget.groupDetail,
                  callback: callback,
                )),
          );
        });
  }
}

class _AddQuestion extends StatefulWidget {
  final dynamic action;
  final dynamic groupDetail;
  final Function callback;
  const _AddQuestion(
      {super.key,
      required this.action,
      required this.groupDetail,
      required this.callback});

  @override
  State<_AddQuestion> createState() => __AddQuestionState();
}

class __AddQuestionState extends State<_AddQuestion> {
  int selectedIndex = 0;
  List listOptions = [];
  List savedOptions = [];
  TextEditingController questionTitle = TextEditingController();
  List<dynamic> listTypeQuetion = [
    {"key": "checkboxes", "title": "Ô để đánh dấu"},
    {"key": "multiple_choice", "title": "Trắc nghiệm"},
    {"key": "written_answer", "title": "Câu hỏi tự do"}
  ];
  setQuestionType(key) {
    int index = listTypeQuetion.indexWhere((element) => element["key"] == key);
    selectedIndex = index;
    if (selectedIndex == 2) {
      listOptions = [];
    }
  }

  addQuestion() {
    if (listOptions.length < 5) {
      listOptions.add("");
      setState(() {});
    }
  }

  deleteOption(index) {
    //listOptions.removeAt(index);
    List newOption = [];
    for (int i = 0; i < listOptions.length; i++) {
      if (i != index) {
        newOption.add(listOptions[i]);
      }
    }
    listOptions = newOption;
    setState(() {});
  }

  checkIsUpdate() {
    if (widget.action != null) {
      setQuestionType(widget.action["question_type"]);
      listOptions = List.from(widget.action["options"]);
      questionTitle.text = widget.action["question_text"];
    }
  }

  validateFields() {
    if (listTypeQuetion[selectedIndex]["key"] == "written_answer") {
      if (questionTitle.text == "") {
        return true;
      } else {
        return false;
      }
    } else {
      if (listOptions.isEmpty || questionTitle.text == "") {
        return true;
      } else {
        bool _haveEmpty = false;
        listOptions.forEach((element) {
          if (element == "") {
            _haveEmpty = true;
          }
        });
        if (_haveEmpty) {
          return true;
        }
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIsUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextFormField(
            keyboardType: TextInputType.multiline,
            controller: questionTitle,
            validator: (value) {
              return null;
            },
            onChanged: (value) {},
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                labelText: "Bạn hỏi gì đi ...",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
          ),
          GestureDetector(
            onTap: () {
              showCustomBottomSheet(context, 200,
                  bgColor: white,
                  title: "Loại câu hỏi",
                  isHaveCloseButton: true,
                  widget: selectQuestionType());
            },
            child: ButtonPrimary(
              label: listTypeQuetion[selectedIndex]["title"],
              isGrey: true,
              icon: const Icon(Icons.arrow_drop_down_sharp),
            ),
          ),
          selectedIndex != 2
              ? Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listOptions.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.82,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                return null;
                              },
                              onChanged: (value) {
                                listOptions[index] = value;
                              },
                              initialValue: listOptions[index],
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  labelText: "Bạn hỏi gì đi ...",
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              deleteOption(index);
                            },
                            child: const Icon(
                              FontAwesomeIcons.circleXmark,
                              size: 25,
                              color: greyColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      addQuestion();
                    },
                    child: const SizedBox(
                      width: 160,
                      child: ButtonPrimary(
                        label: "Thêm lựa chọn",
                        isGrey: true,
                      ),
                    ),
                  ),
                ])
              : Container(),
          Expanded(child: Container()),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ButtonPrimary(
                  isGrey: true,
                  label: "Huỷ",
                  handlePress: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ButtonPrimary(
                  isGrey: validateFields(),
                  label: widget.action != null ? "Lưu" : "Tạo",
                  handlePress: () async {
                    if (validateFields() == false) {
                      if (widget.action != null) {
                        var params = {
                          "id": widget.action["id"],
                          "question_text": questionTitle.text,
                          "options": listOptions,
                          "question_type": listTypeQuetion[selectedIndex]["key"]
                        };

                        updateQuestion(widget.action["id"], params);

                        Navigator.of(context).pop();
                      } else {
                        var params = {
                          "question_text": questionTitle.text,
                          "options": listOptions,
                          "question_type": listTypeQuetion[selectedIndex]["key"]
                        };
                        createQuestion(params);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  updateQuestion(id, params) async {
    GroupApi().updateMemberQuestion(widget.groupDetail["id"], id, params);
    widget.callback(params);
  }

  createQuestion(params) async {
    var res =
        await GroupApi().addMemberQuestion(widget.groupDetail["id"], params);
    widget.callback(res);
  }

  Widget selectQuestionType() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
          itemCount: listTypeQuetion.length,
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    setQuestionType(listTypeQuetion[index]["key"]);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ))),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            listTypeQuetion[index]["title"],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, right: 8),
                        child: Icon(
                          index == selectedIndex
                              ? FontAwesomeIcons.circleDot
                              : FontAwesomeIcons.circle,
                          size: 16,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
