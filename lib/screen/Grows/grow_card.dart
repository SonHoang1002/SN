import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/grow_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class GrowCard extends ConsumerStatefulWidget {
  final dynamic grows;
  const GrowCard({Key? key, this.grows}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<GrowCard> createState() => _GrowCardState();
}

String maxId = '';
List grows = [];

class _GrowCardState extends ConsumerState<GrowCard> {
  late double width;
  late double height;
  var paramsConfig = {"limit": 4};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(growControllerProvider.notifier)
            .getListGrow(paramsConfig));
  }

  @override
  Widget build(BuildContext context) {
    List grows = ref.watch(growControllerProvider).grows;

    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
              child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: grows.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return CardComponents(
                imageCard: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: ImageCacheRender(
                    path: grows[index]['banner']['url'],
                  ),
                ),
                onTap: () {
                  // ref
                  //     .read(growControllerProvider.notifier)
                  //     .getDetailGrow(grows[index]['id']);
                  // Navigator.push(
                  //     context,
                  //     CupertinoPageRoute(
                  //         builder: (context) => GrowDetail(
                  //               growDetail: ref
                  //                   .watch(growControllerProvider)
                  //                   .detailGrow,
                  //             )));
                },
                textCard: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        grows[index]['title'],
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'Cam kết mục tiêu ${grows[index]['target_value'] ~/ 1}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: greyColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        '${grows[index]['followers_count'].toString()} người quan tâm · ${grows[index]['backers_count'].toString()} người ủng hộ',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: greyColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                buttonCard: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 30,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.solidStar,
                                  color: Colors.black, size: 14),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Quan tâm',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 11.0,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 30,
                            width: width * 0.12,
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(width: 0.2, color: greyColor)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(FontAwesomeIcons.solidStar,
                                    color: Colors.black, size: 14),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
        ]),
      ),
    );
  }
}
