import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class MenuRender extends StatelessWidget {
  const MenuRender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Menu của bạn",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List.generate(listSocial.length, (index) {
            return Container(
              width: size.width - 40,
              height: 75,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(
                top: 4,
                bottom: 4,
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(width: 0.1, color: greyColor),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    listSocial[index]['icon'],
                    width: 26,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        listSocial[index]['label'],
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: size.width - 120,
                        child: Text(
                          listSocial[index]['subLabel'],
                          style:
                              const TextStyle(fontSize: 12, color: greyColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
