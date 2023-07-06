import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

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
              colorButton: secondaryColor.withOpacity(0.3),
              icon: Icon(
                FontAwesomeIcons.camera,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                size: size.width > 400 ? 16 : 14,
              ),
              fontSize: size.width > 400 ? 14 : 12,
              colorText: Theme.of(context).textTheme.bodyLarge!.color,
              handlePress: () {
                firstFunction != null ? firstFunction!() : null;
              },
            )),
        buildSpacer(width: 10),
        Flexible(
          flex: 1,
          child: ButtonPrimary(
            label: "Khoảnh khắc của tôi",
            colorButton: greyColor[300],
            icon: Icon(
              FontAwesomeIcons.user,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              size: size.width > 400 ? 16 : 14,
            ),
            fontSize: size.width > 400 ? 14 : 12,
            colorText: Theme.of(context).textTheme.bodyLarge!.color,
            handlePress: () {
              secondFunction != null ? secondFunction!() : null;
            },
          ),
        )
      ],
    );
  }
}
