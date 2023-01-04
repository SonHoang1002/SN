import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class CreateFeedMenu extends StatelessWidget {
  const CreateFeedMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height - 370,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 0.1, color: greyColor))),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 4,
        ),
        itemCount: listMenuPost.length,
        itemBuilder: (context, index) => Container(
          width: size.width / 4,
          height: size.width / 4,
          padding: const EdgeInsets.all(8.0),
          decoration:
              BoxDecoration(border: Border.all(width: 0.1, color: greyColor)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              listMenuPost[index]['image'] != null
                  ? SvgPicture.asset(
                      listMenuPost[index]['image'],
                      width: 26,
                    )
                  : const SizedBox(),
              listMenuPost[index]['icon'] != null
                  ? Icon(
                      listMenuPost[index]['icon'],
                      color: Color(listMenuPost[index]['color']),
                      size: 24,
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 8,
              ),
              Text(
                listMenuPost[index]['label'],
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
