import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:social_network_app_mobile/apis/market_place_apis/province_api.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class CreateUpdateRender extends StatefulWidget {
  final List infoField;
  final VoidCallback callback;
  const CreateUpdateRender(
      {super.key, required this.infoField, required this.callback});

  @override
  State<CreateUpdateRender> createState() => _CreateUpdateRenderState();
}

class _CreateUpdateRenderState extends State<CreateUpdateRender> {
  String selectedAdress = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedAdress = widget.infoField[6]['title'];
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),

      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.infoField.length,
        itemBuilder: (context, index) {
          switch (widget.infoField[index]['type']) {
            case 'blank':
              return const SizedBox(
                height: 50,
              );
            case 'title':
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.infoField[index]['title'],
                    style: const TextStyle(
                        // color:  white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      'Thành công rồi! Bạn đã tạo trang thành công. Hãy bổ sung thông tin chi tiết để mọi người dễ dàng kết nối với bạn nhé.',
                      style: TextStyle(fontSize: 17)),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );

            case 'radio':
              return _buildRadioGroup(
                  widget.infoField[index]['title'],
                  widget.infoField[index]['iconTitle'],
                  widget.infoField[index]['description'],
                  widget.infoField[index]['options'],
                  widget.infoField[index]['radioGroup'],
                  widget.infoField[index]['action'],
                  widget.infoField[index]['valueRadio']);
            case 'autocomplete':
              return _buildAutocomplete(
                  context, selectedAdress, widget.infoField[index]['action']);
            default:
              return _buildTextFormField(
                  widget.infoField[index]['title'],
                  widget.infoField[index]['iconTitle'],
                  widget.infoField[index]['description'],
                  widget.infoField[index]['placeholder'],
                  widget.infoField[index]['type'],
                  widget.infoField[index]['controller'],
                  widget.infoField[index]['for']);
          }
        },

      ),
    );
  }

  bool isValidUrl(String url) {
    // Sử dụng biểu thức chính quy để kiểm tra URL
    final urlPattern = RegExp(
      r"^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$",
      caseSensitive: false,
      multiLine: false,
    );
    return urlPattern.hasMatch(url);
  }

  bool isValidEmail(String email) {
    final emailPattern = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailPattern.hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final phonePattern = RegExp(r'^\d{10}$');
    return phonePattern.hasMatch(phoneNumber);
  }

  Widget _buildTextFormField(
      // TextEditingController controller,
      String? title,
      IconData? iconTitle,
      String? description,
      String placeholder,
      String? type,
      TextEditingController? controller,
      String? fieldType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          if (iconTitle != null && title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey[400]),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 8),
                    child: Icon(
                      iconTitle,
                      size: 18,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          TextFormField(

            controller: controller,
            maxLength: 100,
            onChanged: (value) {
              widget.callback();
            },
            validator: (value) {
              if (value != "") {
                if (fieldType == "web") {
                  if (!isValidUrl(value!)) {
                    return 'Địa chỉ trang web không hợp lệ';
                  }
                } else if (fieldType == "email") {
                  if (!isValidEmail(value!)) {
                    return 'Địa chỉ Email không hợp lệ';
                  }
                } else if (fieldType == "phone") {
                  if (!isValidPhoneNumber(value!)) {
                    return 'Số điện thoại không hợp lệ';
                  }
                } else if (fieldType == "zip") {
                  if (!isValidPhoneNumber(value!)) {
                    return 'Số điện thoại không hợp lệ';
                  }
                }
              }
              return null;

            },
            keyboardType: placeholder == "Email"
                ? TextInputType.emailAddress
                : type == 'number'
                    ? TextInputType.number
                    : null,
            decoration: InputDecoration(
                suffix: placeholder == placeholder
                    ? const Icon(
                        CupertinoIcons.greaterthan,
                        color: white,
                      )
                    : null,
                counterText: "",
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                hintText: placeholder,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 30),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioGroup(String title, IconData iconTitle, String description,
      List options, List radioGroup, Function action, valueRadio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[400]),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(right: 8),
                child: Icon(
                  iconTitle,
                  size: 18,
                ),
              ),
              Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(description, style: const TextStyle(fontSize: 15))
                ],
              )
            ],
          ),
          Column(
            children: List.generate(
                options.length,
                (index) => RadioListTile(
                      groupValue: valueRadio,
                      title: Text(
                        options[0]['title'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        options[0]['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      onChanged: ((value) {
                        action(value);
                      }),
                      value: radioGroup[index],
                    )),
          )
        ],
      ),
    );
  }

  Widget _buildAutocomplete(
      BuildContext context, String title, Function? action) {
    return GestureDetector(
      onTap: () {
        _showBottomSheetForSelect(context, action);
      },
      child: Container(
          height: 56,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(color: Colors.grey, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(selectedAdress,
                    style: TextStyle(
                        color: selectedAdress == widget.infoField[6]['title']
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 16)),
              ),
              const Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ),
            ],
          )),
    );
  }

  _showBottomSheetForSelect(BuildContext context, Function? action) {
    showModalBottomSheet(
        backgroundColor: transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateFull) {

            return DropDownProvinces(
              action: action,
              callback: (p0) {
                Navigator.of(context).pop();
                selectedAdress = p0;
                setState(() {});
              },

            );
          });
        });
  }
}

class DropDownProvinces extends StatefulWidget {
  final Function? action;
  final void Function(String) callback;
  const DropDownProvinces(
      {super.key, required this.action, required this.callback});

  @override
  State<DropDownProvinces> createState() => _DropDownProvincesState();
}

class _DropDownProvincesState extends State<DropDownProvinces> {
  List<dynamic> listSelected = [];
  Future<List> getProvincesList() async {
    List response = await ProvincesApi().getProvinces(null) ?? [];
    return response.map((e) => {'status': false, ...e}).toList();
  }

  fetchData() async {
    List<dynamic> provinces = await getProvincesList();
    setState(() {
      listSelected = provinces;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: height * 0.8,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Column(children: [
        // drag and drop navbar
        Container(
          padding: const EdgeInsets.only(top: 5),
          margin: const EdgeInsets.only(bottom: 10),
          child: Container(
            height: 4,
            width: 40,
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
          ),
        ),
        // province input
        /* SizedBox(
          height: 80,
          child: TextFormField(
            onChanged: ((value) {
              if (widget.action != null) widget.action!();
            }),
            style: const TextStyle(),
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                hintText: "Tìm kiếm tỉnh/ thành phố/ thị xã/ thị trấn",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 30),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ), */
        listSelected.isNotEmpty
            ? SizedBox(
                height: 400,
                child: ListView.builder(
                    itemCount: listSelected.length,
                    itemBuilder: ((context, index) {
                      if (listSelected.isNotEmpty) {
                        return GestureDetector(
                          onTap: () {
                            widget.callback(listSelected[index]["title"]);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Text(
                                      listSelected[index]["title"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(
                                  height: 2,
                                  color: white,
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                            child:
                                Text(" Không có dữ liệu", style: TextStyle()));
                      }
                    })))
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ]),
    );
  }
}
