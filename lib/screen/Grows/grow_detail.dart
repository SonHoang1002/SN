import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/grow_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class GrowDetail extends ConsumerStatefulWidget {
  final dynamic growDetail;
  const GrowDetail({super.key, this.growDetail});

  @override
  ConsumerState<GrowDetail> createState() => _GrowDetailState();
}

class _GrowDetailState extends ConsumerState<GrowDetail> {
  @override
  Widget build(BuildContext context) {
    var growDetails = ref.watch(growControllerProvider).detailGrow;
    var growDetail = widget.growDetail;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 0.2, color: greyColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(FontAwesomeIcons.angleLeft, color: Colors.white, size: 18),
              ],
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: Expanded(
          child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        // child: Hero(
                        //   tag: growDetail['banner']['url'],
                        //   child: ClipRRect(
                        //     child: ImageCacheRender(
                        //       path: growDetail['banner']['url'],
                        //     ),
                        //   ),
                        // ),
                      ),
                    ],
                  )
                ]),
          )
        ],
      )),
    );
  }
}
