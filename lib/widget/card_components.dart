import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

class CardComponents extends StatelessWidget {
  final dynamic buttonCard;
  final dynamic buttonHeight;
  final dynamic textCard;
  final dynamic imageCard;
  final dynamic imageHeight;
  final dynamic onTap;
  final dynamic type;

  const CardComponents({
    Key? key,
    this.buttonCard,
    this.imageCard,
    this.imageHeight,
    this.buttonHeight,
    this.textCard,
    this.onTap,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        color: theme.isDarkMode ? Colors.grey.shade900 : Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: theme.isDarkMode
                  ? Colors.black.withOpacity(0.5)
                  : Colors.grey,
              width: 0.5,
            ),
            borderRadius: type == 'avatarFriend'
                ? const BorderRadius.all(Radius.circular(8))
                : const BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(child: Positioned.fill(child: imageCard)),
                    type == 'homeScreen'
                        ? Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 35.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: 26,
                                    width: 26,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 0.2, color: greyColor)),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(FontAwesomeIcons.ellipsis,
                                              color: Colors.white, size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 26,
                                  width: 26,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 0.2, color: greyColor)),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(FontAwesomeIcons.xmark,
                                            color: Colors.white, size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  child: textCard ?? const SizedBox(),
                ),
                SizedBox(
                  child: buttonCard ?? const SizedBox(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
