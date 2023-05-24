import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Map/map.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class MapWidgetItem extends StatelessWidget {
  const MapWidgetItem({
    super.key,
    required this.checkin,
  });

  final dynamic checkin;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 5.0, right: 4.0, left: 4.0),
      child: Column(
        children: [
          SizedBox(
              height: 150,
              child: MapWidget(
                checkin: checkin,
              )),
          Container(
            color: Colors.grey.withOpacity(0.2),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.2, color: greyColor)),
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
                        checkin['title'],
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
                          description: checkin['address'] ?? ''),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
