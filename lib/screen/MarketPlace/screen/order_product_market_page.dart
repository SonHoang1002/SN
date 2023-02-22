import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../helper/push_to_new_screen.dart';
import 'notification_market_page.dart';

class OrderProductMarketPage extends StatefulWidget {
  const OrderProductMarketPage({super.key});

  @override
  State<OrderProductMarketPage> createState() => _OrderProductMarketPageState();
}

class _OrderProductMarketPageState extends State<OrderProductMarketPage> {
  late double width = 0;
  late double height = 0;
  int length = 3;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return DefaultTabController(
      length: 7, 
      initialIndex: 0,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackIconAppbar(),
                const AppBarTitle(title: "Danh sách đơn hàng"),
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
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.list),
                  child: Text("Tất cả"),
                ),
                Tab(
                    icon: Icon(FontAwesomeIcons.watchmanMonitoring),
                    child: Text("Chờ thanh toán (10)")),
                Tab(
                  icon: Icon(FontAwesomeIcons.list),
                  child: Text("Vận chuyển (10)"),
                ),
                Tab(
                    icon: Icon(FontAwesomeIcons.searchengin),
                    child: Text("Đang giao (10)")),
                Tab(
                    icon: Icon(FontAwesomeIcons.searchengin),
                    child: Text("Hoàn thành")),
                Tab(
                    icon: Icon(FontAwesomeIcons.searchengin),
                    child: Text("Đã hủy")),
                Tab(
                    icon: Icon(FontAwesomeIcons.searchengin),
                    child: Text("Trả hàng/hoàn tiền")),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildAllBody(),
              _buildWaitForPaymentBody(),
              _buildTranferBody(),
              _buildDeliveringBody(),
              _buildCompleteBody(),
              _buildCancelBody(),
              _buildRefundBody(),
            ],
          )),
    );
  }

  Widget _buildAllBody() {
    return _buildBaseBody(_buildOrderComponent());
  }

  Widget _buildWaitForPaymentBody() {
    return _buildBaseBody(_buildOrderComponent());
  }

  Widget _buildTranferBody() {
    return Container(
      color: greyColor,
      height: 200,
    );
  }

  Widget _buildDeliveringBody() {
    return Container(
      color: white,
      height: 200,
    );
  }

  Widget _buildCompleteBody() {
    return Container(
      color: blackColor,
      height: 200,
    );
  }

  Widget _buildCancelBody() {
    return Container(
      color: secondaryColor,
      height: 200,
    );
  }

  Widget _buildRefundBody() {
    return Container(
      color: primaryColor,
      height: 200,
    );
  }

  Widget _buildOrderComponent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: greyColor[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.4, color: greyColor)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              buildTextContent("Chờ thanh toán (2 mục)", true,
                  fontSize: 16, colorWord: Colors.yellow[700]),
            ],
          ),
        ),
        buildDivider(color: red),
        Column(
          children: List.generate(
            length,
            (index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.shop,
                              size: 20,
                            ),
                            buildSpacer(width: 10),
                            buildTextContent(
                                "Real Madrid C.F. Việt Nam", false,
                                fontSize: 14),
                          ],
                        ),
                        const SizedBox()
                      ],
                    ),
                  ),
                  buildDivider(color: red),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GeneralComponent(
                      [
                        buildTextContent(
                            "Real Madrid C.F. Việt Nam Real Madriddfgdfg  C.F. Việt Nam Real Madriddg  dfg   C.F. Việt Nam",
                            false,
                            fontSize: 18),
                        buildSpacer(height: 10),
                      ],
                      preffixFlexValue: 6,
                      prefixWidget: const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: ImageCacheRender(
                          height: 100.0,
                          path:
                              "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
                        ),
                      ),
                      suffixFlexValue: 10,
                      changeBackground: transparent,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  buildSpacer(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Phân loại hạng: ", false,
                          fontSize: 13, colorWord: greyColor),
                      buildTextContent(
                        "White",
                        false,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  buildSpacer(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Số lượng: ", false,
                          fontSize: 13, colorWord: greyColor),
                      buildTextContent(
                        "30",
                        false,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  buildSpacer(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Đơn giá: ", false,
                          fontSize: 13, colorWord: greyColor),
                      buildTextContent(
                        "500000₫",
                        false,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  index == length - 1 ? const SizedBox() : buildDivider(color: red),
                ],
              );
            },
          ),
        ),
        buildDivider(color: red),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextContent("Thành tiền", false, fontSize: 16),
              buildTextContent("1200000₫", true, fontSize: 18),
            ],
          ),
        ),
        Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildButtonForMarketWidget(
                width: width,
                title: "Xem chi tiết",
                function: () {
                  showBottomSheetCheckImportantSettings(
                      bgColor: greyColor[300],
                      context,
                      height * 0.75,
                      "Chi tiết đơn hàng",
                      iconData: FontAwesomeIcons.chevronLeft,
                      widget: Column(children: [
                        _buildBetweenContent("Người nhận", "Nguyen Văn A"),
                        _buildBetweenContent("Số điện thoại", "0346311359"),
                        _buildBetweenContent("Địa chỉ nhận hàng",
                            "180 Hoàng Mai, Hai Bà Trưng,dfd dfg sdfsdf rr ư qwq qư qe qư Hà Nội 180 Hoàng Mai, Hai Bà Trưng, Hà Nội"),
                        _buildBetweenContent(
                            "Thông tin vận chuyển", "Kiện hàng 1"),
                        buildSpacer(height: 5),
                        buildDivider(color: red),
                        // thong tin thanh toán
                        buildTextContent("Thông tin thanh toán", true,
                            fontSize: 22, isCenterLeft: false),
                        ListView(shrinkWrap: true, children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: DataTable(columns: const [
                              DataColumn(
                                  label: Text('STT',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Sản phẩm',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Đơn giá',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Số lượng',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Thành tiền',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ], rows: const [
                              DataRow(cells: [
                                DataCell(Text("1")),
                                DataCell(Text(
                                    "Real Madrid C.F. Việt Nam Real Madriddfgdfg  C.F. Việt Nam Real Madriddg  dfg   C.F. Việt Nam")),
                                DataCell(Text("20000")),
                                DataCell(Text("100")),
                                DataCell(Text("120000")),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("2")),
                                DataCell(Text(
                                    "Đồng Hồ Chế Tác Kim Cương Rolex Yacht Master Black Dial, 42mm")),
                                DataCell(Text("20000")),
                                DataCell(Text("100")),
                                DataCell(Text("120000")),
                              ]),
                            ]),
                          ),
                        ]),
                        _buildBetweenContent("Tổng tiền sản phẩm", "3000000"),
                        _buildBetweenContent("Phí vận chuyển", "1240000"),
                        _buildBetweenContent(
                            "Doanh thu đơn hàng", "480854584",
                            titleBold: true, colorTitle: blackColor),
                        buildSpacer(height: 5),
                        buildDivider(color: red),
                        // thanh toan của người mua
                        buildTextContent("Thanh toán của người mua", true,
                            fontSize: 22, isCenterLeft: false),
                        buildSpacer(height: 10),
                        _buildBetweenContent("Tổng tiền sản phẩm", "3000000"),
                        _buildBetweenContent("Phí vận chuyển", "1240000"),
                        _buildBetweenContent(
                            "Tổng tiền thanh toán", "480854584",
                            titleBold: true, colorTitle: blackColor),
                      ]));
                }),
            buildButtonForMarketWidget(
                width: width,
                title: "Liên hệ với người bán",
                bgColor: blueColor),
            buildButtonForMarketWidget(
                width: width, title: "Hủy đơn hàng", bgColor: red)
          ],
        ),
      ]),
    );
  }
}

Widget _buildBaseBody(Widget widget) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Expanded(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [widget],
            ),
          )
        ],
      ),
    ),
  );
}

Widget _buildBetweenContent(String title, String contents,
    {IconData? iconData,
    bool haveIcon = true,
    bool titleBold = false,
    Color? colorTitle}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            haveIcon
                ? Container(
                    child: Icon(
                      iconData ?? FontAwesomeIcons.locationPin,
                      size: 16,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              width: 5,
            ),
            buildTextContent(title, titleBold,
                fontSize: 14, colorWord: colorTitle ?? greyColor),
          ],
        ),
        const SizedBox(
          width: 30,
        ),
        Flexible(
          flex: 10,
          child: Wrap(
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  contents,
                  textAlign: TextAlign.left,
                  maxLines: 10,
                ),
              ),
            ],
            alignment: WrapAlignment.end,
          ),
        )
      ],
    ),
  );
}
