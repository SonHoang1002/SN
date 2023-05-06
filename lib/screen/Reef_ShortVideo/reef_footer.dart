import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class ReefFooter extends StatelessWidget {
  final Function? firstFunction;
  final Function? secondFunction;
  const ReefFooter({this.firstFunction, this.secondFunction, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
            flex: 1,
            child: ButtonPrimary(
              label: "Tạo",
              icon: Icon(
                FontAwesomeIcons.camera,
                color: blueColor,
                size: size.width > 400 ? 16 : 14,
              ),
              fontSize: size.width > 400 ? 14 : 12,
              handlePress: () {
                firstFunction != null ? firstFunction!() : null;
              },
            )),
        buildSpacer(width: 10),
        Flexible(
          flex: 1,
          child: ButtonPrimary(
            label: "Thước phim của tôi",
            icon: Icon(
              FontAwesomeIcons.user,
              color: blueColor,
              size: size.width > 400 ? 16 : 14,
            ),
            fontSize: size.width > 400 ? 14 : 12,
            handlePress: () {
              secondFunction != null ? secondFunction!() : null;
            },
          ),
        )
      ],
    );
  }
}
