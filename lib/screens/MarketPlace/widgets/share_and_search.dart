import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/image_cache.dart';

// tao user, tim kiem input, danh sach tim kiem

class ShareAndSearchWidget extends StatefulWidget {
  dynamic data;
  String placeholder;
  Function? selectionFunction;
  ShareAndSearchWidget(
      {super.key,
      required this.data,
      required this.placeholder,
      this.selectionFunction});
  @override
  State<ShareAndSearchWidget> createState() => _ShareAndSearchWidgetState();
}

class _ShareAndSearchWidgetState extends State<ShareAndSearchWidget> {
  dynamic _filterData;
  @override
  void initState() {
    super.initState();
    _filterData = widget.data["data"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // user
        GeneralComponent(
          [
            buildTextContent(
              "Chia sẻ với tư cách",
              false,
              fontSize: 15,
            ),
            buildSpacer(height: 5),
            buildTextContent(
              "Nguyen Van A",
              true,
              fontSize: 15,
            ),
          ],
          prefixWidget: Container(
            height: 40.0,
            width: 40.0,
            margin: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const ImageCacheRender(
                height: 40.0,
                width: 40.0,
                path:
                    "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
              ),
            ),
          ),
          changeBackground: transparent,
          isHaveBorder: true,
        ),

        // search
        Container(
          height: 35,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: TextFormField(
            onChanged: ((value) {
              _searchAndFilterData(value);
            }),
            textAlign: TextAlign.left,
            style: const TextStyle(),
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  FontAwesomeIcons.search,
                  color: Colors.grey,
                  size: 13,
                ),
                contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                hintText: widget.placeholder,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(17)))),
          ),
        ),
        // list
        Container(
            height: 376,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _filterData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GeneralComponent(
                        [
                          Text(
                            _filterData[index]["title"],
                            style: const TextStyle(
                                // color: white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          _filterData[index]["subTitle"] != null &&
                                  _filterData[index]["subTitle"] != "" &&
                                  _filterData[index]["subTitle"].isNotEmpty
                              ? Text(
                                  _filterData[index]["subTitle"],
                                  style: const TextStyle(
                                    color: greyColor,
                                    fontSize: 14,
                                  ),
                                )
                              : const SizedBox()
                        ],
                        prefixWidget: Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: transparent,
                          ),
                          child: Image.asset(
                            _filterData[index]["icon"],
                          ),
                        ),
                        suffixWidget: Container(
                            height: 30,
                            width: 30,
                            child: const Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 17,
                            )),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        changeBackground: transparent,
                      ),
                      buildDivider(color: greyColor)
                    ],
                  );
                })),
      ],
    );
  }

  _searchAndFilterData(dynamic value) {
    // _filterData = widget.data["data"].where((element) {
    //   element["title"].contains(value);
    // }).toList();
    List<dynamic> dataList = [];
    for (int i = 0; i < widget.data["data"].length; i++) {
      if (widget.data["data"][i]["title"]
              .toLowerCase()
              .contains((value as String).toLowerCase()) ||
          widget.data["data"][i]["title"]
              .toUpperCase()
              .contains((value as String).toUpperCase())) {
        dataList.add(widget.data["data"][i]);
      }
    }
    _filterData = dataList;
    setState(() {});
  }
}
