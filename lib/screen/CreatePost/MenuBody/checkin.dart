import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/checkin.dart';
import '../../../theme/colors.dart';
import '../../../widget/search_input.dart';
import '../../../widget/text_description.dart';

class Checkin extends StatelessWidget {
  const Checkin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child:  SearchInput()),
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: locations.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    padding: const EdgeInsets.only(bottom: 10.0),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 0.2, color: greyColor))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: const Icon(
                            FontAwesomeIcons.locationDot,
                            size: 16,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width - 80,
                              child: Text(
                                locations[index]['name'],
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            SizedBox(
                              width: size.width - 80,
                              child: TextDescription(
                                  description: locations[index]
                                          ['formatted_address'] ??
                                      ''),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
        )
      ],
    );
  }
}
