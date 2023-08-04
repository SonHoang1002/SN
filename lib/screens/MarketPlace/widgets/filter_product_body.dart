import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/apis/market_place_apis/category_product_apis.dart';
import 'package:market_place/apis/market_place_apis/products_api.dart';
import 'package:market_place/apis/market_place_apis/province_api.dart';
import 'package:market_place/constant/get_min_max_price.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/products_provider.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';

class FilterPageBody extends ConsumerStatefulWidget {
  final dynamic categoryData;
  final dynamic shopId;
  final Function? callbackFunction;
  final Function(List newList)? updateDataFunction;

  const FilterPageBody(
      {super.key,
      this.categoryData,
      this.shopId,
      this.callbackFunction,
      this.updateDataFunction});

  @override
  ConsumerState<FilterPageBody> createState() => _FilterPageBodyState();
}

const String titleCategory = "category";
const String titleChildCategory = "child_category";
const String titleProvince = "titleProvince";
List filterList = [
  {'key': "popular", "title": "Phổ biến"},
  {'key': "newest", "title": "Mới nhất"},
  {'key': "sold", "title": "Bán chạy"},
  {'key': "currency", "title": "Giá"},
];

class _FilterPageBodyState extends ConsumerState<FilterPageBody> {
  bool _isLoading = true;
  Size? size;
  dynamic _filterSelected;
  // true: up , false: down
  bool _filterPrice = true;
  bool _isAdvancedFilter = false;
  List childCategorySelected = [];

  List listProvince = [];
  List listChildCategory = [];
  List listCategory = [];
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
        if (widget.shopId != null) {
          listProduct =
              await ProductsApi().getShopProducts(widget.shopId, {"limit": 10});
        } else {
          listProduct = ref.read(productsProvider).list;
        }

        widget.updateDataFunction != null
            ? widget.updateDataFunction!(listProduct)
            : null;
        setState(() {
          _isLoading = false;
        });
        listCategory = await getChildCategoriesList();
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
    }
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
    widget.updateDataFunction != null
        ? widget.updateDataFunction!(listProduct)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.sizeOf(context);
    return Stack(children: [
      // main content
      _isLoading
          ? Center(
              child: buildCircularProgressIndicator(),
            )
          : widget.updateDataFunction == null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      buildSpacer(height: 50),
                      Flexible(
                        child: SuggestListComponent(
                            context: context,
                            title: const SizedBox(),
                            contentList: listProduct),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
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
                                          widget.callbackFunction != null
                                              ? widget.callbackFunction!()
                                              : null;
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
                                                    color: _filterSelected == e
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
                          _isAdvancedFilter = !_isAdvancedFilter;
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
                _isAdvancedFilter
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: _buildCustomGeneralWidget(titleCategory,
                                    () {
                              showAddvancedSelectionsBottomSheet(
                                  titleCategory, "Ngành hàng",
                                  onSelected: (dynamic value) {
                                handleGetChildProductList(value);
                              });
                            })),
                            buildSpacer(width: 20),
                            Flexible(
                                child: _buildCustomGeneralWidget(titleProvince,
                                    () {
                              showAddvancedSelectionsBottomSheet(
                                  titleProvince, "Thành phố");
                            })),
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          _isAdvancedFilter
              ? Expanded(
                  child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAdvancedFilter = false;
                    });
                  },
                  child: Container(
                    color: greyColor.withOpacity(0.1),
                  ),
                ))
              : const SizedBox()
        ],
      ),
    ]);
  }

  handleGetChildProductList(dynamic value) async {
    // {id: 4638, text: Thời Trang Nam,
    //icon: https://s3-hn-2.cloud.cmctelecom.vn/sn-web/images/product_categories/icon_categories/Th%E1%BB%9Di%20Trang%20Nam.png,
    //parent_category_id: null,
    //has_children: true, level: 1, category_attributes: []}
    if (value?['has_children'] == true) {
      listChildCategory = await CategoryProductApis()
          .getChildCategoryProductApi(value?['id'], {"subcategories": true});
      setState(() {});
      showAddvancedSelectionsBottomSheet(titleChildCategory, value['text'],
          onSelected: (dynamic value) { 
      });
    } else {
      setState(() {
        childCategorySelected.add(value);
      });
      popToPreviousScreen(context);
    }
  }

  Future<List> getProvincesList() async {
    List response = await ProvincesApi().getProvinces({"limit": 40}) ?? [];
    return response.map((e) => {'status': false, ...e}).toList();
  }

  Future<List> getChildCategoriesList() async {
    if (widget.categoryData != null) {
      return await CategoryProductApis().getChildCategoryProductApi(
          widget.categoryData?['id'], {"subcategories": true});
    } else {
      return await CategoryProductApis().getParentCategoryProductApi();
    }
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
      if (key == titleProvince && provinceStatusList.isNotEmpty) {
        await ref
            .read(productsProvider.notifier)
            .getProductsSearch({"province_id": provinceStatusList[0]['id']});
        listProduct = ref.watch(productsProvider).list;
        setState(() {
          _isAdvancedFilter = false;
        });
      }
    }, widget: StatefulBuilder(builder: (context, setStatefull) {
      return FutureBuilder<List>(
          future: key == titleProvince
              ? (listProvince.isEmpty ? getProvincesList() : null)
              : key == titleCategory
                  ? (listProvince.isEmpty ? getChildCategoriesList() : null)
                  : null,
          builder: (context, result) {
            if (result.connectionState == ConnectionState.done ||
                (key == titleProvince && listProvince.isNotEmpty) ||
                (key == titleCategory && listCategory.isNotEmpty) ||
                (key == titleChildCategory && listChildCategory.isNotEmpty)) {
              var datas;
              if (key == titleProvince) {
                datas = listProvince.isNotEmpty ? listProvince : result.data!;
              } else if (key == titleCategory) {
                datas =
                    (listProvince.isNotEmpty ? listCategory : (result.data!));
              } else if (key == titleChildCategory) {
                datas = (listChildCategory.isNotEmpty
                    ? listChildCategory
                    : (result.data!));
              } else {
                datas = result.data!;
              }
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
                        } else if (key == titleProvince) {
                          setState(() {
                            listProvince[index]['status'] =
                                !listProvince[index]['status'];
                          });
                          setStatefull(() {});
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
                                  key == titleProvince
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
                                                setStatefull(() {});
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
            key == titleCategory
                ? ((widget.categoryData?['text']) ?? "Ngành hàng")
                : key == 'titleProvince'
                    ? "Thành phố"
                    : "",
            false,
            fontSize: 12,
            colorWord: greyColor),
        buildSpacer(height: 3),
        buildTextContent(
          key == titleCategory
              ? (renderValueConsequence(childCategorySelected, "-->") ?? "--")
              : key == 'titleProvince'
                  ? renderProvinceStatusList.isNotEmpty
                      ? renderValueConsequence(renderProvinceStatusList, ",")
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

  renderValueConsequence(List listData, String regex) {
    return listData
        .map(
          (e) => ((e?['title']) ?? (e?['text'])),
        )
        .toList()
        .join(" $regex ")
        .toString();
  }
}
