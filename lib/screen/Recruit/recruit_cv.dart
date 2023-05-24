import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/config.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/recruit/recruit_provider.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecruitCV extends ConsumerStatefulWidget {
  const RecruitCV({super.key});

  @override
  ConsumerState<RecruitCV> createState() => _RecruitCVState();
}

class _RecruitCVState extends ConsumerState<RecruitCV> {
  late double width;
  late double height;
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero,
        () => ref.read(recruitControllerProvider.notifier).getListRecruitCV());
  }

  @override
  Widget build(BuildContext context) {
    List recruitsCV = ref.watch(recruitControllerProvider).recruitsCV;
    bool isMore = ref.watch(recruitControllerProvider).isMore;

    final Completer<WebViewController> controller =
        Completer<WebViewController>();
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        Future.delayed(
            Duration.zero,
            () => ref
                .read(recruitControllerProvider.notifier)
                .getListRecruitCV());
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Thư viện nội dung của bạn',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            recruitsCV.isNotEmpty
                ? SizedBox(
                    child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recruitsCV.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: CardComponents(
                          imageCard: SizedBox(
                            height: 180,
                            width: width,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: ExtendedImage.network(
                                recruitsCV[index]['template'] ??
                                    linkBannerDefault,
                              ),
                            ),
                          ),
                          onTap: () {
                            var id = recruitsCV[index]['id'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: WebView(
                                    initialUrl:
                                        '$urlWebEmso/recruit_detail/$id',
                                    javascriptMode: JavascriptMode.unrestricted,
                                    onWebViewCreated:
                                        (WebViewController webViewController) {
                                      controller.complete(webViewController);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          textCard: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0, right: 16.0, left: 16.0, top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    recruitsCV[index]['title'],
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ))
                : const SizedBox(),
            isMore == true
                ? const Center(child: CupertinoActivityIndicator())
                : recruitsCV.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/wow-emo-2.gif",
                              height: 125.0,
                              width: 125.0,
                            ),
                          ),
                          const Text('Không tìm thấy kết quả nào'),
                        ],
                      )
                    : const SizedBox()
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
