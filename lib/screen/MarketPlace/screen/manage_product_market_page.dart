import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/create_product_market_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import 'detail_product_market_page_old.dart';
import 'notification_market_page.dart';

class ManageProductMarketPage extends StatefulWidget {
  @override
  State<ManageProductMarketPage> createState() =>
      _ManageProductMarketPageState();
}

class _ManageProductMarketPageState extends State<ManageProductMarketPage> {
  late double width = 0;
  late double height = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackIconAppbar(),
              AppBarTitle(title: "Quản lý sản phẩm"),
              GestureDetector(
                onTap: () {
                  pushToNextScreen(context, NotificationMarketPage());
                },
                child: Icon(
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: [
                    buildTextContent(
                        "chỉ người bán mới thấy được cái này", true,
                        fontSize: 20, colorWord: red, isCenterLeft: false),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          _buildManageComponent(
                              MaangeProductMarketConstants
                                  .MANAGE_PRODUCT_BOTTOM_SELECTIONS["name"],
                              MaangeProductMarketConstants
                                  .MANAGE_PRODUCT_BOTTOM_SELECTIONS["data"]),
                          _buildManageComponent(
                              MaangeProductMarketConstants
                                  .MANAGE_PRODUCT_BOTTOM_SELECTIONS["name"],
                              MaangeProductMarketConstants
                                  .MANAGE_PRODUCT_BOTTOM_SELECTIONS["data"]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            //
          ],
        ));
  }

  _buildManageComponent(String nameOfProduct, dynamic data) {
    List<DataRow> dataRowList = [];
    for (int i = 0; i < data.length; i++) {
      dataRowList.add(
        DataRow(cells: [
          DataCell(Text(data[i]["classify_category"])),
          DataCell(Text(data[i]["sku"])),
          DataCell(Text(data[i]["price"].toString())),
          DataCell(Text(data[i]["repository"].toString())),
        ]),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      // padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: greyColor[300], borderRadius: BorderRadius.circular(7)),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(nameOfProduct, true,
                  fontSize: 13, colorWord: red, isCenterLeft: false)
            ],
            preffixFlexValue: 4,
            prefixWidget: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(7)),
                child: ImageCacheRender(
                  height: 100.0,
                  path:
                      "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
                ),
              ),
            ),
            suffixFlexValue: 5,
            suffixWidget: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.pen),
                                title: const Text("Cập nhật"),
                                onTap: () {
                                  popToPreviousScreen(context);
                                  pushToNextScreen(
                                      context, CreateProductMarketPage());
                                },
                              ),
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.copy),
                                title: const Text("Sao chép"),
                                onTap: () {
                                  popToPreviousScreen(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("sao chép thành công")));
                                },
                              ),
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.eye),
                                title: const Text("Xem trước"),
                                onTap: () {
                                  popToPreviousScreen(context);
                                  pushToNextScreen(
                                      context, OldDetailProductMarketPage(id: "2"));
                                },
                              ),
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.trashCan),
                                title: const Text("Xóa"),
                                onTap: () {
                                  popToPreviousScreen(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(child: Icon(FontAwesomeIcons.ellipsis)),
            ),
            padding: EdgeInsets.zero,
            changeBackground: transparent,
            function: () {
              showBottomSheetCheckImportantSettings(
                  context, 470, "Chi tiết sản phẩm",
                  bgColor: greyColor[300],
                  widget: Container(
                    child: Column(children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: buildTextContent("Tên sản phẩm", false,
                                fontSize: 14),
                          ),
                          Flexible(
                            flex: 10,
                            child: buildTextContent(nameOfProduct, true,
                                fontSize: 18, colorWord: red),
                          ),
                        ],
                      ),
                      buildDivider(color: red),
                      Container(
                        height: 320,
                        child: ListView(children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(columns: [
                              DataColumn(
                                  label: Text('Phân loại hàng',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('SKU phân loại',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Giá',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Kho hàng',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ], rows: dataRowList),
                          ),
                        ]),
                      ),
                    ]),
                  ));
            },
          )
        ],
      ),
    );
  }
}
