import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/Map/map_expanded.dart';

class MapWidget extends StatelessWidget {
  final dynamic checkin;
  final double zoom;
  final dynamic interactiveFlags;
  final dynamic type;
  const MapWidget(
      {Key? key,
      this.checkin,
      this.zoom = 13,
      this.type,
      this.interactiveFlags = InteractiveFlag.all})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return FlutterMap(
      options: MapOptions(
        center: LatLng(checkin['location']['lat'], checkin['location']['lng']),
        zoom: zoom,
        interactiveFlags: interactiveFlags,
      ),
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: ((context) =>  MapExpanded(checkin: checkin, type: type))));
          },
          child: type == 'custom_map'
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                  child: TileLayer(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/thanghoa1420/cl8dw369f000114pdxdhvyrf3/tiles/512/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidGhhbmdob2ExNDIwIiwiYSI6ImNsOGNzaGNraTBvaXozcW9mOTZvemlxM3QifQ.amy7PdzwTqaolJMVQzpGSg",
                      subdomains: const [
                        'a',
                        'b',
                        'c'
                      ],
                      additionalOptions: const {
                        "access_token":
                            "pk.eyJ1IjoidGhhbmdob2ExNDIwIiwiYSI6ImNsOGNzaGNraTBvaXozcW9mOTZvemlxM3QifQ.amy7PdzwTqaolJMVQzpGSg",
                      }),
                )
              : TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/thanghoa1420/cl8dw369f000114pdxdhvyrf3/tiles/512/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidGhhbmdob2ExNDIwIiwiYSI6ImNsOGNzaGNraTBvaXozcW9mOTZvemlxM3QifQ.amy7PdzwTqaolJMVQzpGSg",
                  subdomains: const [
                      'a',
                      'b',
                      'c'
                    ],
                  additionalOptions: const {
                      "access_token":
                          "pk.eyJ1IjoidGhhbmdob2ExNDIwIiwiYSI6ImNsOGNzaGNraTBvaXozcW9mOTZvemlxM3QifQ.amy7PdzwTqaolJMVQzpGSg",
                    }),
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(
                  checkin['location']['lat'], checkin['location']['lng']),
              builder: (ctx) => const Icon(
                FontAwesomeIcons.locationDot,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
