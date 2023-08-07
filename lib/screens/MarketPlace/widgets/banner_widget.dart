import 'dart:async';
import 'dart:math';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../../providers/market_place_providers/campaine_provider.dart';

// final images = [
//   "https://cf.shopee.vn/file/vn-50009109-887cd5d6731ad6a896933d64481bb9be_xxhdpi",
//   "https://cf.shopee.vn/file/vn-50009109-fe2b75a010b39320279e97ad329c0a6d_xxhdpi",
//   "https://cf.shopee.vn/file/vn-50009109-46c997d2198d0e54a630a98be899f111_xxhdpi",
//   "https://cf.shopee.vn/file/vn-50009109-a0b6221b2f8ddea5332d327fc538bbb3_xxhdpi",
//   "https://cf.shopee.vn/file/vn-50009109-d0a7893a1eb1a44a44e0e2f89aac54e1_xxhdpi",
//   "https://cf.shopee.vn/file/vn-50009109-4c08eb4d89a9f5713a44251de3290f3f_xxhdpi",
//   "https://cf.shopee.vn/file/vn-50009109-92067fd9d5b91c55d1886c72a68e67b4_xxhdpi"
// ];

class CustomBanner extends ConsumerStatefulWidget {
  const CustomBanner({
    super.key,
  });

  @override
  CustomBannerState createState() => CustomBannerState();
}

class CustomBannerState extends ConsumerState<CustomBanner> {
  final _controller = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;
  Timer? _timer;
  List images = [];
  @override
  void initState() {
    // if (mounted) return;
    super.initState();

    Future.delayed(Duration.zero, () async {
      final campaine = await ref.read(campaineProvider.notifier).getCampaine();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (ref.read(campaineProvider).listCampaine.isNotEmpty) {
          setState(() {
            images = ref
                .read(campaineProvider)
                .listCampaine
                .map((e) => (e['banner']['url']))
                .toList()
                .where((ele) => ele != null)
                .toList();
          });
        }
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < images.length - 1) {
        setState(() {
          _currentPage++;
        });
      } else {
        setState(() {
          _currentPage = 0;
        });
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.removeListener(() {
  //     _timer!.cancel();
  //   });
  //   _timer = null;
  //   _currentPage = 0;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: null,
        builder: (context, snapshot) {
          return SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  padEnds: false,
                  controller: _controller,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: ExtendedImage.network(
                        images[index] ?? linkBannerDefault,
                        width: MediaQuery.sizeOf(context).width,
                        fit: BoxFit.cover,
                        height: 200.0,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: _currentPage == index
                              ? secondaryColor
                              : secondaryColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
