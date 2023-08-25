import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/common_api.dart';
import 'package:social_network_app_mobile/data/checkin.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class Checkin extends StatefulWidget {
  final Function handleUpdateData;
  final dynamic checkin;
  final String type;
  const Checkin(
      {Key? key,
      required this.handleUpdateData,
      this.checkin,
      required this.type})
      : super(key: key);

  @override
  State<Checkin> createState() => _CheckinState();
}

class _CheckinState extends State<Checkin> {
  List listRenders = locations;
  dynamic locationSelected;

  @override
  void initState() {
    super.initState();
    if (mounted && widget.checkin != null) {
      setState(() {
        locationSelected = widget.checkin;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  handleSearch(value) {
    if (value.isEmpty) {
      setState(() {
        listRenders = locations;
      });
      return;
    }
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
        () {
      fetchLocations({"keyword": value});
    });
  }

  fetchLocations(params) async {
    var response = await CommonApi().fetchDataLocation(params);
    if (response != null) {
      setState(() {
        listRenders = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: locationSelected != null
                ? Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                        color: primaryColorSelected,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: size.width - 70,
                            child: Text(
                              locationSelected['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            )),
                        InkWell(
                          onTap: () {
                            widget.handleUpdateData('update_checkin', null);
                            setState(() {
                              locationSelected = null;
                            });
                          },
                          child: Icon(
                            FontAwesomeIcons.xmark,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  )
                : SearchInput(
                    handleSearch: handleSearch,
                  )),
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: listRenders.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        locationSelected = listRenders[index];
                        widget.handleUpdateData(
                            'update_checkin', listRenders[index]);
                        if (widget.type == 'menu_out') {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      padding: const EdgeInsets.only(bottom: 10.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 0.2, color: greyColor))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border:
                                    Border.all(width: 0.2, color: greyColor)),
                            child: const Icon(
                              FontAwesomeIcons.locationDot,
                              size: 16,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width - 80,
                                child: Text(
                                  listRenders[index]['title'],
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
                                    description:
                                        listRenders[index]['address'] ?? ''),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
        )
      ],
    );
  }
}
