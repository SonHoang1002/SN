import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class MapExpanded extends StatefulWidget {
  final dynamic checkin;
  final dynamic type;
  const MapExpanded({Key? key, this.checkin, this.type}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MapExpanded createState() => _MapExpanded();
}

class _MapExpanded extends State<MapExpanded> {
  @override
  void initState() {
    super.initState();
  }

  void _launchMapsApp() async {
    final latitude = widget.checkin['location']['lat'];
    final longitude = widget.checkin['location']['lng'];

    String url;
    if (Platform.isIOS) {
      url = 'comgooglemaps://?q=$latitude,$longitude&zoom=13';
    } else {
      url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              AppBarTitle(
                title: '${widget.checkin['address'] ?? ''}',
              ),
              Container(),
            ],
          )),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.checkin['location']['lat'], widget.checkin['location']['lng']),
          zoom: 13,
          minZoom: 0,
          maxZoom: 19,
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          // Stop following the location marker on the map if user interacted with the map.
          onPositionChanged: (MapPosition position, bool hasGesture) {},
        ),
        // ignore: sort_child_properties_last
        children: [
          TileLayer(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/thanghoa1420/cl8dw369f000114pdxdhvyrf3/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidGhhbmdob2ExNDIwIiwiYSI6ImNsOGNzaGNraTBvaXozcW9mOTZvemlxM3QifQ.amy7PdzwTqaolJMVQzpGSg",
            subdomains: const ['a', 'b', 'c'],
            additionalOptions: const {
              "access_token": "pk.eyJ1IjoidGhhbmdob2ExNDIwIiwiYSI6ImNsOGNzaGNraTBvaXozcW9mOTZvemlxM3QifQ.amy7PdzwTqaolJMVQzpGSg",
            },
            maxZoom: 25,
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(widget.checkin['location']['lat'], widget.checkin['location']['lng']),
                builder: (ctx) => const Icon(
                  FontAwesomeIcons.locationDot,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
        nonRotatedChildren: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: 115,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  _launchMapsApp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  // padding: const EdgeInsets.symmetric(
                  //   horizontal: 16.0,
                  //   vertical: 12.0,
                  // ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                child: const Text(
                  'Xem đường đi',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
