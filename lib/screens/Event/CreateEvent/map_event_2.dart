import 'package:easy_debounce/easy_debounce.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/providers/map_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class MapEvent2 extends ConsumerStatefulWidget {
  const MapEvent2({
    Key? key,
    required this.categorySelected,
    required this.onCategorySelectedChanged,
  }) : super(key: key);
  final dynamic categorySelected;
  final Function(List<dynamic>) onCategorySelectedChanged;

  @override
  // ignore: library_private_types_in_public_api
  _MapEventState createState() => _MapEventState();
}

class _MapEventState extends ConsumerState<MapEvent2> {
  List categorySelected = [];
  List categorySearch = [];
  var param = {"limit": 100};

  @override
  void initState() {
    super.initState();
    categorySelected = widget.categorySelected;
  }

  handleSearch(value) async {
    if (value.isEmpty) return;

    categorySearch = await UserPageApi().getHobbiesByCategories(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                right: 12.0, left: 12.0, bottom: 10.0, top: 10.0),
            child: SearchInput(
              handleSearch: handleSearch,
            ),
          ),
          categorySelected.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                      right: 12.0, left: 15.0, bottom: 10.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đang chọn',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  categorySelected[0]['icon'] != null
                                      ? ExtendedImage.network(
                                          categorySelected[0]['icon'],
                                          width: 34.0,
                                          height: 34.0,
                                        )
                                      : Container(
                                          height: 34,
                                          width: 34,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: const Icon(
                                            FontAwesomeIcons.circleUser,
                                            size: 20.0,
                                            color: greyColor,
                                          ),
                                        ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width - 80,
                                          child: Text(
                                            categorySelected[0]['text'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              widget.onCategorySelectedChanged([]);
                              setState(() {
                                categorySelected = [];
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Icon(FontAwesomeIcons.xmark, size: 20),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          categorySearch.isNotEmpty
              ? const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 10.0, top: 10.0),
                  child: Text(
                    'Gợi ý',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "Không tìm thấy sở thích nào",
                    ),
                  ),
                ),
          Expanded(
            child: SizedBox(
              height: size.height * 0.6,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                shrinkWrap: true,
                itemCount: categorySearch.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      widget
                          .onCategorySelectedChanged([(categorySearch[index])]);
                      Navigator.pop(context, categorySearch);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 12.0, left: 12.0, bottom: 10.0),
                      child: Row(
                        children: [
                          categorySearch[index]['icon'] != null
                              ? ExtendedImage.network(
                                  categorySearch[index]['icon'],
                                  width: 20.0,
                                  height: 20.0,
                                )
                              : Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.circleUser,
                                    size: 20.0,
                                    color: greyColor,
                                  ),
                                ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width - 80,
                                  child: Text(
                                    categorySearch[index]['text'],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
