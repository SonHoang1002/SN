import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/map_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class MapEvent extends ConsumerStatefulWidget {
  const MapEvent({
    Key? key,
    required this.checkinSelected,
    required this.onCheckinSelectedChanged,
  }) : super(key: key);
  final dynamic checkinSelected;
  final Function(List<dynamic>) onCheckinSelectedChanged;

  @override
  // ignore: library_private_types_in_public_api
  _MapEventState createState() => _MapEventState();
}

class _MapEventState extends ConsumerState<MapEvent> {
  List checkinSelected = [];
  var param = {"limit": 100};

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero,
        () =>
            ref.read(mapControllerProvider.notifier).getListMapCheckin(param));
    checkinSelected = widget.checkinSelected;
  }

  handleSearch(value) {
    if (value.isEmpty) return;
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
        () {
      ref
          .read(mapControllerProvider.notifier)
          .getListMapCheckin({"keyword": value});
    });
  }

  @override
  Widget build(BuildContext context) {
    List checkin = ref.watch(mapControllerProvider).checkin;
    final size = MediaQuery.of(context).size;
    return checkin.isNotEmpty
        ? SizedBox(
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
                checkinSelected.isNotEmpty
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
                                        Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            border: Border.all(
                                                width: 0.2, color: greyColor),
                                          ),
                                          child: const Icon(
                                            FontAwesomeIcons.locationDot,
                                            size: 16,
                                            color: primaryColor,
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
                                                  checkinSelected[0]['title'],
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              SizedBox(
                                                width: size.width - 80,
                                                child: TextDescription(
                                                  description:
                                                      checkinSelected[0]
                                                              ['address'] ??
                                                          '',
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
                                    widget.onCheckinSelectedChanged([]);
                                    setState(() {
                                      checkinSelected = [];
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 25.0),
                                    child:
                                        Icon(FontAwesomeIcons.xmark, size: 20),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                checkinSelected.isNotEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(
                            left: 16.0, bottom: 10.0, top: 10.0),
                        child: Text(
                          'Gợi ý',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: SizedBox(
                    height: size.height * 0.6,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      shrinkWrap: true,
                      itemCount: checkin.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            widget.onCheckinSelectedChanged([(checkin[index])]);
                            Navigator.pop(context, checkinSelected);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 12.0, left: 12.0, bottom: 10.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                          width: 0.2, color: greyColor)),
                                  child: const Icon(
                                    FontAwesomeIcons.locationDot,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width - 80,
                                        child: Text(
                                          checkin[index]['title'],
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      SizedBox(
                                        width: size.width - 80,
                                        child: TextDescription(
                                            description: checkin[index]
                                                    ['address'] ??
                                                ''),
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
          )
        : const Center(
            child: CupertinoActivityIndicator(),
          );
  }
}
