import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class CreateUpdateRender extends StatelessWidget {
  final List infoField;
  const CreateUpdateRender({super.key, required this.infoField});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: infoField.length,
      itemBuilder: (context, index) {
        switch (infoField[index]['type']) {
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
                  infoField[index]['title'],
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
                infoField[index]['title'],
                infoField[index]['iconTitle'],
                infoField[index]['description'],
                infoField[index]['options'],
                infoField[index]['radioGroup'],
                infoField[index]['action'],
                infoField[index]['valueRadio']);
          case 'autocomplete':
            return _buildAutocomplete(context, infoField[index]['title'],
                infoField[index]['action'], infoField[index]['listSelect']);
          default:
            return _buildTextFormField(
              infoField[index]['title'],
              infoField[index]['iconTitle'],
              infoField[index]['description'],
              infoField[index]['placeholder'],
              infoField[index]['type'],
            );
        }
      },
    );
  }

  Widget _buildTextFormField(
    // TextEditingController controller,
    String? title,
    IconData? iconTitle,
    String? description,
    String placeholder,
    String? type,
  ) {
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
            maxLength: 100,
            onChanged: ((value) {}),
            validator: (value) {
              if (value != null) {}
              return null;
            },
            keyboardType: type == 'number' ? TextInputType.number : null,
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
      BuildContext context, String title, Function? action, List listSelect) {
    return GestureDetector(
      onTap: () {
        _showBottomSheetForSelect(context, action, listSelect);
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
                child: Text(title,
                    style: const TextStyle(color: Colors.grey, fontSize: 16)),
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

  _showBottomSheetForSelect(
      BuildContext context, Function? action, List listSelected) {
    showModalBottomSheet(
        backgroundColor: transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateFull) {
            final height = MediaQuery.sizeOf(context).height;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: height * 0.8,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
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
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    onChanged: ((value) {
                      if (action != null) action();
                    }),
                    style: const TextStyle(color: white),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
                SizedBox(
                    height: 250,
                    child: ListView.builder(
                        itemCount: listSelected.length,
                        itemBuilder: ((context, index) {
                          if (listSelected.isNotEmpty) {
                            return Container(
                              padding: const EdgeInsets.only(left: 10),
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
                                        listSelected[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  )),
                                  const Divider(
                                    height: 2,
                                    color: white,
                                  )
                                ],
                              ),
                            );
                          }
                          return const Center(
                              child: Text(" Không có dữ liệu",
                                  style: TextStyle(color: white)));
                        }))),
              ]),
            );
          });
        });
  }
}
