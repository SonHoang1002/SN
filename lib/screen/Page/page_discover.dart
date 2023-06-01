import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';

import '../../providers/page/page_list_provider.dart';

class PageDiscover extends ConsumerStatefulWidget {
  const PageDiscover({super.key});

  @override
  ConsumerState<PageDiscover> createState() => _PageDiscoverState();
}

class _PageDiscoverState extends ConsumerState<PageDiscover> {
  @override
  Widget build(BuildContext context) {
    List pageDiscover = ref.read(pageListControllerProvider).pageSuggestions;
    return Column(
      children: [
        SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: pageDiscover.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ExtendedImage.network(
                      pageDiscover[index]['banner'] != null
                          ? pageDiscover[index]['banner']['preview_url']
                          : linkBannerDefault),
                );
              }),
        ),
      ],
    );
  }
}
