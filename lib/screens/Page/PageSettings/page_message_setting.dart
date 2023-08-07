import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/page/page_message_provider.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import '../../../widgets/messenger_app_bar/app_bar_title.dart';

class PageMessage extends ConsumerStatefulWidget {
  final dynamic data;
  const PageMessage({super.key, this.data});

  @override
  ConsumerState<PageMessage> createState() => _PageMessageState();
}

class _PageMessageState extends ConsumerState<PageMessage> {
  bool saveAvaliable = true;
  List<PageMesssagesState> qlist = [
    PageMesssagesState(question: 'Xin chào', response: 'Chào bạn'),
    PageMesssagesState(
        question: 'Sản phẩm này còn không', response: 'Còn sản phẩm'),
  ];
  var key = UniqueKey();
  @override
  void initState() {
    super.initState();
    getList();
  }

  void onItemDelete(int index) {
    qlist.removeAt(index);
    key = UniqueKey();
    checkValidateState();
  }

  void checkValidateState() {
    for (int i = 0; i < qlist.length; i++) {
      if (qlist[i].question == "" || qlist[i].response == "") {
        setState(() {
          saveAvaliable = false;
        });
      } else {
        setState(() {
          saveAvaliable = true;
        });
      }
    }
  }

  void onItemValidateStatusChange(String question, String response, int index) {
    qlist[index - 1].question = question;
    qlist[index - 1].response = response;
    qlist[index - 1].isNew = false;
    checkValidateState();
  }

  void getList() {
    final listPosts = ref.read(pageMesssagesProvider).toList();
    //if (listPosts.length > 0) {
    qlist = listPosts;
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Cài đặt trang và gắn thẻ'),
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
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Cài đặt tin nhắn tự động",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Câu hỏi thường gặp",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Text(
                      "Gợi ý những câu mà mọi người có thể hỏi Trang của bạn, rồi thiết lập tin trả lời tự động cho các câu hỏi đó.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        key: key,
                        itemCount: qlist.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => EditableListItem(
                              isNew: qlist[index].isNew,
                              onItemDelete: () => onItemDelete(index),
                              onItemValidateStatusChange:
                                  onItemValidateStatusChange,
                              index: index + 1,
                              initialQuestion: qlist[index].question ?? "",
                              initialResponse: qlist[index].response ?? "",
                            )),
                    ButtonPrimary(
                      label: "Thêm lựa chọn",
                      handlePress: () {
                        setState(() {
                          saveAvaliable = false;
                          qlist.add(PageMesssagesState(
                              index: qlist.length,
                              question: "",
                              response: "",
                              isNew: true));
                        });
                      },
                      fontSize: 12,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 14,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: saveAvaliable == false
                              ? const ButtonPrimary(
                                  label: 'Lưu thay đổi',
                                  handlePress: null,
                                  colorButton: Color(0xff808080),
                                )
                              : ButtonPrimary(
                                  label: 'Lưu thay đổi',
                                  handlePress: () {
                                    //widget.onChange(valueText);

                                    ref
                                        .read(pageMesssagesProvider.notifier)
                                        .updateState(qlist);
                                    Navigator.pop(context);
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
                                qlist = [];
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditableListItem extends StatefulWidget {
  final int index;
  final bool? isNew;
  final String initialQuestion;
  final String initialResponse;
  final Function() onItemDelete;
  final Function(String, String, int) onItemValidateStatusChange;

  const EditableListItem(
      {super.key,
      required this.initialQuestion,
      required this.initialResponse,
      required this.index,
      required this.onItemDelete,
      this.isNew = false,
      required this.onItemValidateStatusChange});

  @override
  _EditableListItemState createState() => _EditableListItemState();
}

class _EditableListItemState extends State<EditableListItem> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  late TextEditingController _questionController;
  late TextEditingController _contentController;
  int _currentQuestionLength = 0;
  int _currentResponseLength = 0;
  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.initialQuestion);
    _contentController = TextEditingController(text: widget.initialResponse);
    _currentQuestionLength = widget.initialQuestion.length;
    _currentResponseLength = widget.initialResponse.length;
    if (widget.isNew == true) {
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập đủ thông tin';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: _isEditing
          ? Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: theme.isDarkMode
                    ? Theme.of(context).cardColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Câu hỏi ${widget.index}:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _isEditing = false;
                                    widget.onItemDelete();
                                  },
                                  child: Icon(Icons.close),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: const VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState?.validate() ==
                                        true) {
                                      setState(() {
                                        _isEditing = false;
                                      });
                                    }
                                  },
                                  child:
                                      Icon(Icons.keyboard_arrow_down_outlined),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _questionController,
                        maxLength: 50,
                        validator: _validateText,
                        onChanged: (value) {
                          setState(() {
                            _currentQuestionLength = value.length;
                            _formKey.currentState?.validate();
                            if (value.length == 0) {
                              widget.onItemValidateStatusChange(
                                  _questionController.text,
                                  _contentController.text,
                                  widget.index);
                            } else {
                              widget.onItemValidateStatusChange(
                                  _questionController.text,
                                  _contentController.text,
                                  widget.index);
                            }
                          });
                        },
                        decoration: InputDecoration(
                          counterText:
                              "${_currentQuestionLength}/50", // Hiển thị số ký tự đã nhập
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Câu trả lời",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _contentController,
                        maxLength: 500,
                        validator: _validateText,
                        onChanged: (value) {
                          setState(() {
                            _currentResponseLength = value.length;
                            _formKey.currentState?.validate();
                            if (value.length == 0) {
                              widget.onItemValidateStatusChange(
                                  _questionController.text,
                                  _contentController.text,
                                  widget.index);
                            } else {
                              widget.onItemValidateStatusChange(
                                  _questionController.text,
                                  _contentController.text,
                                  widget.index);
                            }
                          });
                        },
                        decoration: InputDecoration(
                          counterText:
                              "${_currentResponseLength}/500", // Hiển thị số ký tự đã nhập
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: theme.isDarkMode
                    ? Theme.of(context).cardColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          "Câu hỏi ${widget.index}: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                _questionController.text,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Icon(
                      Icons.edit,
                      size: 14,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class Message {
  String? question;
  String? response;

  Message({this.question, this.response});

  Message copyWith(String data1, String data2) {
    return Message(question: data1, response: data2);
  }
}
