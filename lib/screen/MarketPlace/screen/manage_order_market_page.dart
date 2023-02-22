import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../helper/push_to_new_screen.dart';
import 'notification_market_page.dart';

class ManageOrderMarketPage extends StatefulWidget {
  const ManageOrderMarketPage({super.key});

  @override
  State<ManageOrderMarketPage> createState() => _ManageOrderMarketPageState();
}

class _ManageOrderMarketPageState extends State<ManageOrderMarketPage> {
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
              const BackIconAppbar(),
              const AppBarTitle(title: "Quản lý đơn hàng"),
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
                children: [_buildManageOrderComponent()],
              ),
            ),
            //
          ],
        ));
  }
}

Widget _buildManageOrderComponent() {
  return SingleChildScrollView(
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: DataTable(
          showBottomBorder: true,
          columns: const [
            DataColumn(
                label: Text('Sản phẩm',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Số lượng',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Tổng đơn hàng',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Trạng thái',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Đơn vị vận chuyển',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Thành tiền',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
          rows: _buildDataRow()),
    ),
  );
}

List<DataRow> _buildDataRow() {
  List<String> status = ["Bị hủy", "Giao hàng nhanh", "Bình thường"];
  List<DataRow> dataRowList = [];
  for (int i = 0; i < 20; i++) {
    dataRowList.add(
      DataRow(cells: [
        DataCell(GeneralComponent(
          [
            Row(
              children: [
                buildTextContent("Nguyen Van A - ", true),
                buildSpacer(height: 10),
                buildTextContent("Mã đơn hàng: ", false),
                buildTextContent("${Random().nextInt(100)}", true),
              ],
            )
          ],
          prefixWidget: Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: const ImageCacheRender(
                height: 30.0,
                width: 30.0,
                path:
                    "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
              ),
            ),
          ),
          changeBackground: transparent,
          padding: EdgeInsets.zero,
        )),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
      ]),
    );
    dataRowList.add(
      DataRow(cells: [
        const DataCell(
          Text(
            "This is a very long sentence that needs to be broken into multiple lines.",
            overflow: TextOverflow.ellipsis,
            maxLines: 100,
          ),
        ),
        const DataCell(Text("120")),
        const DataCell(Text("20000")),
        DataCell(buildTextContent(status[Random().nextInt(2)], true,
            colorWord: red)),
        const DataCell(Text("ExpressVN")),
        const DataCell(Text("2000000000")),
      ]),
    );
  }
  return dataRowList;
}
