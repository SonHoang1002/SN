import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:market_place/apis/market_place_apis/products_api.dart';
import 'package:market_place/apis/market_place_apis/voucher_api.dart';

import 'package:market_place/constant/common.dart';
import 'package:market_place/helpers.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/page_list_provider.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';
import '../../../../theme/colors.dart';
import 'create_voucher.dart';

class MainVoucher extends ConsumerStatefulWidget {
  const MainVoucher({super.key});

  @override
  ConsumerState<MainVoucher> createState() => _MainVoucherState();
}

class _MainVoucherState extends ConsumerState<MainVoucher> {
  late double width = 0;
  late double height = 0;
  Color? colorTheme;

  List? _pageList;
  dynamic _selectedPage;
  int _selectedTab = 0;
  List vouchers = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (ref.watch(pageListProvider).listPage.isEmpty) {
        final pageList =
            await ref.read(pageListProvider.notifier).getPageList();
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          _initMainData();
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageList = [];
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabList = [
      "Đang hoạt động",
      "Sắp diễn ra",
      "Đã kết thúc"
    ];

    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    colorTheme = ThemeMode.dark == true
        ? Theme.of(context).cardColor
        : const Color(0xfff1f2f5);
    Color colorWord = ThemeMode.dark == true
        ? white
        : true == ThemeMode.light
            ? blackColor
            : greyColor;
    Future.wait([_initMainData()]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Mã giảm giá của shop"),
              GestureDetector(
                onTap: () {},
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
            buildTextContent("Đây là những voucher mà bạn đã tạo", true,
                fontSize: 13, colorWord: greyColor, isCenterLeft: false),
            buildSpacer(height: 10),
            filterPage(context, "Chọn Page", "Chọn Page"),
            buildSpacer(height: 10),
            if (_selectedPage?["id"] != null)
              Expanded(
                child: DefaultTabController(
                  length: tabList.length,
                  child: Scaffold(
                    body: Column(
                      children: [
                        TabBar(
                          onTap: (value) {
                            setState(() {
                              vouchers = [];
                              _selectedTab = value;
                            });
                          },
                          tabs: tabList.map((e) {
                            return Tab(
                              child: SizedBox(
                                width: width * 0.43,
                                child: buildTextContent(
                                  e,
                                  false,
                                  isCenterLeft: false,
                                  colorWord: colorWord,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ContentVoucherPage(
                                vouchers: vouchers,
                                statusVoucher: "now",
                                pageId: _selectedPage['id'],
                              ),
                              ContentVoucherPage(
                                  vouchers: vouchers,
                                  statusVoucher: "upcoming",
                                  pageId: _selectedPage['id']),
                              ContentVoucherPage(
                                  vouchers: vouchers,
                                  statusVoucher: "past",
                                  pageId: _selectedPage['id']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ));
  }

  Future _initMainData() async {
    await _initPageList();
    if (_selectedPage != null && _selectedPage!.isNotEmpty) {
      if (vouchers.isEmpty) {
        if (_selectedTab == 0) {
          final response =
              await VoucerApis().getVoucher(_selectedPage["id"], "now", 10);
          setState(() {
            vouchers = response["data"];
          });
        } else if (_selectedTab == 1) {
          final response = await VoucerApis()
              .getVoucher(_selectedPage["id"], "upcoming", 10);
          setState(() {
            vouchers = response["data"];
          });
        } else if (_selectedTab == 2) {
          final response =
              await VoucerApis().getVoucher(_selectedPage["id"], "past", 10);
          setState(() {
            vouchers = response["data"];
          });
        }
      }
    }
    return 0;
  }

  Future _initPageList() async {
    if (_pageList == null || _pageList!.isEmpty) {
      _pageList = await ref.watch(pageListProvider).listPage;
      setState(() {});
    }
    if (_pageList!.isNotEmpty) {
      if (_selectedPage == null || _selectedPage!.isEmpty) {
        setState(() {
          _selectedPage = _pageList![0];
        });
      }
    }
  }

  Widget filterPage(
    BuildContext context,
    String title,
    String titleForBottomSheet,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 14),
              const SizedBox(height: 5),
              _selectedPage != null
                  ? buildTextContent(_selectedPage["title"], true, fontSize: 16)
                  : buildTextContent("-", true, fontSize: 16)
            ],
            prefixWidget: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                  height: 35,
                  width: 35,
                  child: _selectedPage != null
                      ? ImageCacheRender(
                          path: _selectedPage?["avatar_media"]?["url"] ??
                              linkAvatarDefault)
                      : Container(
                          color: greyColor,
                        )),
            ),
            suffixWidget: const SizedBox(
              height: 40,
              width: 40,
              child: Icon(
                FontAwesomeIcons.caretDown,
                size: 18,
              ),
            ),
            changeBackground: transparent,
            padding: const EdgeInsets.all(5),
            isHaveBorder: true,
            function: () {
              showCustomBottomSheet(context, 500,
                  title: titleForBottomSheet,
                  widget: SizedBox(
                    height: 400,
                    child: FutureBuilder<void>(
                        future: _initPageList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return _pageList!.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _pageList!.length,
                                    itemBuilder: (context, index) {
                                      final data = _pageList![index];
                                      if (data.length == 0) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            buildTextContent(
                                                "Bạn chưa sở hữu trang nào, vui lòng tạo page trước",
                                                false),
                                          ],
                                        );
                                      }
                                      return Column(
                                        children: [
                                          GeneralComponent(
                                            [
                                              buildTextContent(
                                                  data["title"], false)
                                            ],
                                            prefixWidget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              child: SizedBox(
                                                height: 35,
                                                width: 35,
                                                child: data["avatar_media"] !=
                                                        null
                                                    ? ImageCacheRender(
                                                        path:
                                                            data["avatar_media"]
                                                                ["url"])
                                                    : null,
                                              ),
                                            ),
                                            changeBackground: transparent,
                                            function: () async {
                                              setState(() {
                                                _selectedPage = data;
                                                vouchers = [];
                                              });
                                              popToPreviousScreen(context);
                                            },
                                          ),
                                          buildDivider(color: greyColor)
                                        ],
                                      );
                                    })
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildTextContent(
                                          "Bạn chưa sở hữu page nào", false,
                                          isCenterLeft: false, fontSize: 18),
                                      buildSpacer(height: 10),
                                      buildMarketButton(contents: [
                                        buildTextContent("Tạo Page", false,
                                            fontSize: 13)
                                      ], width: width * 0.4)
                                    ],
                                  );
                          }
                          return buildCircularProgressIndicator();
                        }),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

class ContentVoucherPage extends StatefulWidget {
  final List vouchers;
  final String statusVoucher;
  final String pageId;
  const ContentVoucherPage(
      {super.key,
      required this.vouchers,
      required this.statusVoucher,
      required this.pageId});

  @override
  State<ContentVoucherPage> createState() => _ContentVoucherPageState();
}

class _ContentVoucherPageState extends State<ContentVoucherPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color colorWord = ThemeMode.dark == true
        ? white
        : true == ThemeMode.light
            ? blackColor
            : greyColor;
    final size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        widget.vouchers.isEmpty
            ? Expanded(
                child: _isLoading
                    ? buildCircularProgressIndicator()
                    : buildTextContent("Bạn chưa tạo voucher nào", true,
                        colorWord:
                            Theme.of(context).textTheme.bodyMedium!.color,
                        isCenterLeft: false),
              )
            : Expanded(
                child: SingleChildScrollView(
                    child: Column(
                children: List.generate(widget.vouchers.length, (index) {
                  return VoucherWidget(
                    pageId: widget.pageId,
                    objectItem: widget.vouchers[index],
                    statusVoucher: widget.statusVoucher,
                  );
                }),
              ))),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
          child: Container(
              alignment: Alignment.center,
              width: size.width * 0.8,
              height: 50,
              child: const Text(
                "Tạo voucher mới",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              )),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateVoucherPage(
                                    type: 'shop',
                                    pageId: widget.pageId,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                buildTextContent("Tạo voucher toàn Shop", true,
                                    colorWord: colorWord,
                                    fontSize: 18,
                                    isCenterLeft: false),
                                const SizedBox(
                                  height: 5,
                                ),
                                buildTextContent(
                                    "Có thể áp dụng voucher này cho toàn bộ sản phẩm trong shop của bạn",
                                    false,
                                    colorWord: colorWord,
                                    isCenterLeft: false,
                                    fontSize: 14),
                              ],
                            )),
                        const Divider(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateVoucherPage(
                                    type: 'products',
                                    pageId: widget.pageId,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                buildTextContent("Tạo voucher sản phẩm", true,
                                    colorWord: colorWord,
                                    fontSize: 18,
                                    isCenterLeft: false),
                                buildTextContent(
                                    "Có thể áp dụng voucher này cho một số sản phẩm nhật định trong shop của bạn",
                                    false,
                                    colorWord: colorWord,
                                    isCenterLeft: false,
                                    fontSize: 14),
                              ],
                            )),
                        const Divider(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: buildTextContent("Thoát", true,
                                colorWord: colorWord,
                                fontSize: 20,
                                isCenterLeft: false)),
                      ],
                    ),
                  );
                });
          },
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

class VoucherWidget extends StatelessWidget {
  final String pageId;
  final dynamic objectItem;
  final String statusVoucher;

  const VoucherWidget({
    super.key,
    required this.pageId,
    required this.objectItem,
    required this.statusVoucher,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeStart = DateTime.parse(objectItem["start_time"]);
    String startTime = DateFormat('dd-MM-yyy').format(dateTimeStart);
    DateTime dateTimeEnd = DateTime.parse(objectItem["end_time"]);
    String endTime = DateFormat('dd-MM-yyy').format(dateTimeEnd);
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                    image: AssetImage(
                        objectItem["discount_type"] == "fix_amount"
                            ? "assets/images/voucher_amount_discount.png"
                            : "assets/images/voucher_percent_discount.png")),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "$startTime - $endTime",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(fontSize: 16),
                            children: [
                          TextSpan(
                            text: objectItem["discount_type"] == "by_percentage"
                                ? '%'
                                : 'đ',
                            style: TextStyle(
                              decoration:
                                  objectItem["discount_type"] == "by_percentage"
                                      ? TextDecoration.none
                                      : TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: objectItem["amount"].toString(),
                          ),
                        ])),
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            children: [
                          const TextSpan(
                            text: 'Đơn tối thiểu: ',
                          ),
                          const TextSpan(
                            text: 'đ',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: objectItem["minimum_basket_price"].toString(),
                          ),
                        ])),
                  ],
                ),
              ],
            ),
            Container(
              color: statusVoucher == "now"
                  ? Colors.green
                  : statusVoucher == "upcoming"
                      ? Colors.blue
                      : Colors.grey,
              child: statusVoucher == "now"
                  ? const Text("Đang diễn ra")
                  : statusVoucher == "upcoming"
                      ? const Text("Sắp diễn ra")
                      : const Text("Đã hết hạn"),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Loại mã: ${objectItem["applicable_products"] == "all_products" ? "Mã giảm giá toàn shop" : "Áp dụng cho một số sản phẩm"}"),
              Text("Đã dùng: ${objectItem["used_count"]}")
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Colors.grey, width: 2), //<-- SEE HERE
                      ),
                      onPressed: (DateTime.parse(objectItem["end_time"])
                                  .isBefore(DateTime.now()) ||
                              statusVoucher == "now")
                          ? null
                          : () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CreateVoucherPage(
                                    type: objectItem["applicable_products"] ==
                                            "all_products"
                                        ? 'shop'
                                        : "products",
                                    pageId: pageId,
                                    objectItem: objectItem,
                                  );
                                },
                              ));
                            },
                      child: const Text("Chỉnh sửa"))),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Colors.grey, width: 2), //<-- SEE HERE
                      ),
                      onPressed: (DateTime.parse(objectItem["end_time"])
                                  .isBefore(DateTime.now()) ||
                              statusVoucher == "now")
                          ? null
                          : () async {
                              final response = await VoucerApis().endVoucher(
                                  objectItem["id"],
                                  DateFormat('dd-MM-yyy')
                                      .format(DateTime.now())
                                      .toString());
                              if (response == null ||
                                  response?["error"] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Không thể kết thúc mã giảm giá",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                      child: const Text("Kết thúc")))
            ],
          ),
        ),
        const Divider(
          height: 10,
        )
      ]),
    );
  }
}
