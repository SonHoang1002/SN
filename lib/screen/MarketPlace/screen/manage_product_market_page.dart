import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import 'update_market_place.dart';
import 'notification_market_page.dart';

class ManageProductMarketPage extends ConsumerStatefulWidget {
  const ManageProductMarketPage({super.key});

  @override
  ConsumerState<ManageProductMarketPage> createState() =>
      _ManageProductMarketPageState();
}

class _ManageProductMarketPageState
    extends ConsumerState<ManageProductMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _productList;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final getProduct =
          ref.read(suggestProductsProvider.notifier).getSuggestProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    _productList = ref.watch(suggestProductsProvider).listSuggest;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Quản lý sản phẩm"),
              GestureDetector(
                onTap: () {
                  pushToNextScreen(context, NotificationMarketPage());
                },
                child: const Icon(
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
              child: ListView(
                children: [
                  buildTextContent("Chỉ người bán mới thấy được cái này", true,
                      fontSize: 20, colorWord: red, isCenterLeft: false),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                          children: List.generate(
                        _productList!.length,
                        (index) {
                          return _buildManageComponent(_productList![index]);
                        },
                      ).toList()),
                    ),
                  )
                ],
              ),
            ),
            //
          ],
        ));
  }

  Widget _buildManageComponent(dynamic data) {
    List<DataRow> dataRowList = [];
    for (int i = 0; i < data["product_variants"].length; i++) {
      dataRowList.add(
        DataRow(cells: [
          DataCell(Text(data["product_variants"][i]["option1"] == null ||
                  data["product_variants"][i]["option2"] == null
              ? "Không có mô tả"
              : "${data["product_variants"][i]["option1"]} ${data["product_variants"][i]["option2"] != null ? " - ${data["product_variants"][i]["option2"]}" : ""}")),
          DataCell(Text(data["product_variants"][i]["sku"])),
          DataCell(Text(data["product_variants"][i]["price"].toString())),
          DataCell(Text(data["brand"].toString())),
        ]),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      // padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: greyColor[300], borderRadius: BorderRadius.circular(7)),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(data["title"].toString(), true,
                  fontSize: 13, colorWord: primaryColor, isCenterLeft: false)
            ],
            preffixFlexValue: 4,
            prefixWidget: Container(
              width: 100,
              margin: EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(7)),
                child: ImageCacheRender(
                  height: 100.0,
                  path: data["product_image_attachments"].isNotEmpty &&
                          data["product_image_attachments"] != null
                      ? data["product_image_attachments"][0]["attachment"]
                          ["url"]
                      : "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
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
                                      context,
                                      UpdateMarketPage(
                                          // data:data
                                          ));
                                },
                              ),
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.copy),
                                title: const Text("Sao chép"),
                                onTap: () {
                                  popToPreviousScreen(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Sao chép thành công")));
                                },
                              ),
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.eye),
                                title: const Text("Xem trước"),
                                onTap: () {
                                  popToPreviousScreen(context);
                                  pushToNextScreen(context,
                                      DetailProductMarketPage(id: data["id"]));
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
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: const Icon(FontAwesomeIcons.ellipsis)),
            ),
            padding: EdgeInsets.zero,
            changeBackground: transparent,
            function: () {
              showBottomSheetCheckImportantSettings(
                  context, 500, "Chi tiết sản phẩm",
                  bgColor: greyColor[300],
                  widget: Container(
                    // margin: EdgeInsets.symmetric(vertical: 10),
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
                            child: buildTextContent(data["title"], true,
                                fontSize: 18, colorWord: secondaryColor),
                          ),
                        ],
                      ),
                      buildDivider(color: primaryColor),
                      Container(
                        height: 290,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(columns: const [
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
