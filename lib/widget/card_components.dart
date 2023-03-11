import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class CardComponents extends StatelessWidget {
  final dynamic buttonCard;
  final dynamic buttonHeight;
  final dynamic textCard;
  final dynamic imageCard;
  final dynamic imageHeight;
  final dynamic onTap;
  final dynamic type;

  const CardComponents(
      {super.key,
      this.buttonCard,
      this.imageCard,
      this.imageHeight,
      this.buttonHeight,
      this.textCard,
      this.onTap,
      this.type});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 184,
                child: Stack(
                  children: [
                    Positioned.fill(child: imageCard),
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
              ),
              SizedBox(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [textCard],
                    )),
              ),
              SizedBox(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: buttonCard),
              )
            ],
          ),
        ),
      ),
    );
  }
}
