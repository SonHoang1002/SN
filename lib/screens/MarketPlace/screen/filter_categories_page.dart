import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/category_product_apis.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/province_api.dart';
import 'package:social_network_app_mobile/constant/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart'; 
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart'; 
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart'; 

class FilterPage extends ConsumerStatefulWidget {
  final dynamic categoryId;
  const FilterPage({super.key, this.categoryId});

  @override
  ConsumerState<FilterPage> createState() => _FilterPageState();
}

const String childCategory = "childCategory";
const String province = "province";
List filterList = [
  {'key': "popular", "title": "Phổ biến"},
  {'key': "newest", "title": "Mới nhất"},
  {'key': "sold", "title": "Bán chạy"},
  {'key': "currency", "title": "Giá"},
];

class _FilterPageState extends ConsumerState<FilterPage> {
  bool _isLoading = true;
  Size? size;
  dynamic _filterSelected;
  // true: up , false: down
  bool _filterPrice = true;
  bool _isAddvancedFilter = false;
  dynamic childCategorySelected;
  List listProvince = [];
  List listChildCategory = [];
  List listProduct = [];
  ValueNotifier<List<bool>> listProvinceStatus = ValueNotifier([]);

  @override
  void initState() {
    if (!mounted) {
      return;
    }
    _filterSelected = filterList[0];

    Future.delayed(Duration.zero, () async {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        // if (ref.read(productsProvider).list.isNotEmpty) {
        listProduct = ref.read(productsProvider).list;
        setState(() {
          _isLoading = false;
        });
        // }
        listChildCategory = await getChildCategoriesList();
        listProvince = await getProvincesList();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _filterDiscover() {
    List<dynamic> filterDiscoverList = ref.watch(productsProvider).list;
    const String popular = "popular";
    const String newest = "newest";
    const String sold = "sold";

    if (_filterSelected['key'] == newest) {
      for (int i = 0; i < filterDiscoverList.length - 1; i++) {
        for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
          if (DateTime.parse(filterDiscoverList[j]["created_at"])
                  .microsecondsSinceEpoch <
              DateTime.parse(filterDiscoverList[j + 1]["created_at"])
                  .microsecondsSinceEpoch) {
            dynamic temp = filterDiscoverList[j];
            filterDiscoverList[j] = filterDiscoverList[j + 1];
            filterDiscoverList[j + 1] = temp;
          }
        }
      }
    } else if (_filterSelected['key'] == sold) {
      for (int i = 0; i < filterDiscoverList.length - 1; i++) {
        for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
          if (filterDiscoverList[j]["sold"] <
              filterDiscoverList[j + 1]["sold"]) {
            dynamic temp = filterDiscoverList[j];
            filterDiscoverList[j] = filterDiscoverList[j + 1];
            filterDiscoverList[j + 1] = temp;
          }
        }
      }
    } else {}
    if (_filterSelected == filterList[3]) {
      if (!_filterPrice) {
        // min to max
        for (int i = 0; i < filterDiscoverList.length - 1; i++) {
          for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
            if (getMinAndMaxPrice(
                    filterDiscoverList[j]["product_variants"])[1] <
                getMinAndMaxPrice(
                    filterDiscoverList[j + 1]["product_variants"])[1]) {
              dynamic temp = filterDiscoverList[j];
              filterDiscoverList[j] = filterDiscoverList[j + 1];
              filterDiscoverList[j + 1] = temp;
            }
          }
        }
      } else {
        // max to min
        for (int i = 0; i < filterDiscoverList.length - 1; i++) {
          for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
            if (getMinAndMaxPrice(
                    filterDiscoverList[j]["product_variants"])[0] >
                getMinAndMaxPrice(
                    filterDiscoverList[j + 1]["product_variants"])[0]) {
              dynamic temp = filterDiscoverList[j];
              filterDiscoverList[j] = filterDiscoverList[j + 1];
              filterDiscoverList[j + 1] = temp;
            }
          }
        }
      }
    }
    setState(() {
      listProduct = filterDiscoverList;
    });
  }

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            AppBarTitle(title: "Lọc theo hạng mục"),
            Icon(
              FontAwesomeIcons.bell,
              size: 18,
              color: Colors.black,
            )
          ],
        ),
      ),
      body: Stack(children: [
        // main content
        _isLoading
            ? Center(
                child: buildCircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    buildSpacer(height: 50),
                    Flexible(
                      child: buildSuggestListComponent(
                          context: context,
                          title: const SizedBox(),
                          contentList: listProduct),
                    ),
                  ],
                ),
              ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: secondaryColor, width: 0.4)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: filterList
                            .map((e) => Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (_filterSelected != e) {
                                              _filterSelected = e;
                                            }
                                            if (_filterSelected ==
                                                filterList[3]) {
                                              _filterPrice = !_filterPrice;
                                            }
                                            _filterDiscover();
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            buildTextContent(
                                              e['title'],
                                              true,
                                              colorWord: _filterSelected == e
                                                  ? secondaryColor
                                                  : null,
                                              fontSize: 12,
                                            ),
                                            e == filterList[3]
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Image.asset(
                                                      _filterSelected == e
                                                          ? (_filterPrice
                                                              ? "assets/icons/up_icon.png"
                                                              : "assets/icons/down_icon.png")
                                                          : "assets/icons/average_icon.png",
                                                      height: 9,
                                                      color:
                                                          _filterSelected == e
                                                              ? secondaryColor
                                                              : null,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isAddvancedFilter = !_isAddvancedFilter;
                          });
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/filter_icon.png",
                              height: 12,
                            ),
                            buildSpacer(width: 5),
                            buildTextContent(
                              "Lọc",
                              true,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  _isAddvancedFilter
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Flex(
                            direction: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: _buildCustomGeneralWidget(
                                      childCategory, () {
                                showAddvancedSelectionsBottomSheet(
                                    childCategory, "Ngành hàng",
                                    onSelected: (dynamic value) {
                                  popToPreviousScreen(context);
                                  setState(() {
                                    childCategorySelected = value;
                                  });
                                });
                              })),
                              buildSpacer(width: 20),
                              Flexible(
                                  child:
                                      _buildCustomGeneralWidget(province, () {
                                showAddvancedSelectionsBottomSheet(
                                    province, "Thành phố");
                              })),
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            const SizedBox()
          ],
        ),
      ]),
    );
  }

  Future<List> getProvincesList() async {
    List response = await ProvincesApi().getProvinces({"limit": 40}) ?? [];
    return response.map((e) => {'status': false, ...e}).toList();
  }

  Future<List> getChildCategoriesList() async {
    return await CategoryProductApis()
        .getChildCategoryProductApi(widget.categoryId, {"subcategories": true});
  }

  bool checkDuplicate(List<dynamic> array1, List<dynamic> array2) {
    // Kiểm tra độ dài của hai mảng
    if (array1.length != array2.length) {
      return false;
    }

    // Sắp xếp hai mảng theo thứ tự tăng dần
    array1.sort();
    array2.sort();

    // So sánh từng phần tử của hai mảng
    for (int i = 0; i < array1.length; i++) {
      if (array1[i] != array2[i]) {
        return false;
      }
    }

    return true;
  }

  showAddvancedSelectionsBottomSheet(dynamic key, String title,
      {Function? onSelected}) {
    showCustomBottomSheet(context, 400, isShowCloseButton: true, title: title,
        onEnd: () async {
      final provinceStatusList = listProvince
          .where(
            (element) => element['status'] == true,
          )
          .toList();
      if (key == province && provinceStatusList.isNotEmpty) {
        await ref
            .read(productsProvider.notifier)
            .getProductsSearch({"province_id": provinceStatusList[0]['id']});
        listProduct = ref.watch(productsProvider).list;

        setState(() {
          _isAddvancedFilter = false;
        });
      }
    }, widget: StatefulBuilder(builder: (context, setStatefullBuilder) {
      return FutureBuilder<List>(
          future: key == province
              ? (listProvince.isEmpty ? getProvincesList() : null)
              : key == childCategory
                  ? (listProvince.isEmpty ? getChildCategoriesList() : null)
                  : null,
          builder: (context, result) {
            if (result.connectionState == ConnectionState.done ||
                (key == province && listProvince.isNotEmpty) ||
                (key == childCategory && listChildCategory.isNotEmpty)) {
              final datas = key == province
                  ? (listProvince.isNotEmpty ? listProvince : result.data!)
                  : key == childCategory
                      ? (listProvince.isNotEmpty
                          ? listChildCategory
                          : result.data!)
                      : result.data!;
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (onSelected != null) {
                          onSelected(datas[index]);
                        } else if (key == province) {
                          setState(() {
                            listProvince[index]['status'] =
                                !listProvince[index]['status'];
                          });
                          setStatefullBuilder(() {});
                        }
                      },
                      child: Column(
                        children: [
                          buildDivider(color: greyColor),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 5, bottom: 5, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildTextContent(
                                    datas[index]['title'] ??
                                        datas[index]['text'],
                                    false,
                                  ),
                                  key == province
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                              value: listProvince[index]
                                                  ['status'],
                                              onChanged: (value) {
                                                setState(() {
                                                  listProvince[index]
                                                          ['status'] =
                                                      value as bool;
                                                });
                                                setStatefullBuilder(() {});
                                              }),
                                        )
                                      : const SizedBox()
                                ],
                              )),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return Center(child: buildCircularProgressIndicator());
          });
    }));
  }

  Widget _buildCustomGeneralWidget(dynamic key, Function onTapFunction) {
    List renderProvinceStatusList =
        listProvince.where((element) => element['status'] == true).toList();
    return GeneralComponent(
      [
        buildTextContent(
            key == childCategory
                ? "Ngành hàng"
                : key == 'province'
                    ? "Thành phố"
                    : "",
            false,
            fontSize: 12,
            colorWord: greyColor),
        buildSpacer(height: 3),
        buildTextContent(
          key == childCategory
              ? (childCategorySelected?['text'] ?? "--")
              : key == 'province'
                  ? renderProvinceStatusList.isNotEmpty
                      ? renderProvinceStatusList
                          .map(
                            (e) => e['title'],
                          )
                          .toList()
                          .join(", ")
                          .toString()
                      : "--"
                  : "",
          false,
          fontSize: 14,
          // maxLines: 1,
          // overflow: TextOverflow.ellipsis
        ),
      ],
      padding: const EdgeInsets.only(left: 7, top: 5, bottom: 5, right: 5),
      changeBackground: transparent,
      isHaveBorder: true,
      borderRadiusValue: 7,
      suffixWidget: const Icon(
        FontAwesomeIcons.caretDown,
        size: 15,
      ),
      function: onTapFunction,
    );
  }
}
