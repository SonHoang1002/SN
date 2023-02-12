import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final dynamic checkin;
  const MapWidget({Key? key, this.checkin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(checkin['location']['lat'], checkin['location']['lng']),
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
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
