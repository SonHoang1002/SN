import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingBlock extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final size;
  // ignore: prefer_typing_uninitialized_variables
  final listMenu;
  // ignore: prefer_typing_uninitialized_variables
  final Function updateIndexPageState;
  const SettingBlock(
      {Key? key, this.size, this.listMenu, required this.updateIndexPageState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        width: size.width - 50,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Column(
                children: List.generate(
                    listMenu.length,
                    (index) => InkWell(
                          child: MenuItem(
                              size: size,
                              item: listMenu[index],
                              borderBottom: index < listMenu.length - 1),
                          onTap: () {
                            updateIndexPageState(listMenu[index]);
                          },
                        )))
          ],
        ));
  }
}

class MenuItem extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final item;
  // ignore: prefer_typing_uninitialized_variables
  final borderBottom;
  const MenuItem({
    super.key,
    required this.size,
    this.item,
    this.borderBottom,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: borderBottom ? 10 : 0),
      child: Column(children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: item['background'], shape: BoxShape.circle),
              child: Icon(
                item["icon"],
                size: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.width - 114,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width - 150,
                    child: Text(
                      item['label'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.angleRight,
                          size: 20, color: Colors.grey.withOpacity(0.5))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        borderBottom
            ? Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.3),
                    height: 1,
                  )
                ],
              )
            : Container()
      ]),
    );
  }
}
