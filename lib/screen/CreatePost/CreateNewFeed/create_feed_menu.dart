import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class CreateFeedMenu extends StatelessWidget {
  final Function handleChooseMenu;
  const CreateFeedMenu({
    super.key,
    required this.handleChooseMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 0.1, color: greyColor))),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            crossAxisCount: 4,
          ),
          itemCount: listMenuPost.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              handleChooseMenu(listMenuPost[index]);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  listMenuPost[index]['image'] != null
                      ? SvgPicture.asset(
                          listMenuPost[index]['image'],
                          width: 20,
                        )
                      : const SizedBox(),
                  listMenuPost[index]['icon'] != null
                      ? Icon(
                          listMenuPost[index]['icon'],
                          color: Color(listMenuPost[index]['color']),
                          size: 18,
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    listMenuPost[index]['label'],
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}