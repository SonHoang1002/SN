import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/screens/Grows/grow_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';

class GrowPast extends ConsumerStatefulWidget {
  const GrowPast({Key? key}) : super(key: key);

  @override
  ConsumerState<GrowPast> createState() => _GrowPastState();
}

class _GrowPastState extends ConsumerState<GrowPast> {
  var configParams = {"limit": 10, "only_current_user": true, "time": "past"};
  final scrollController = ScrollController();
  bool isLoading = false;
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero, () => fetchData(configParams));
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId =
            ref.read(growControllerProvider).growsDonatedOver.last['id'];
        fetchData({"max_id": maxId, ...configParams});
      }
    });
  }

  void fetchData(params) async {
    setState(() {
      isLoading = true;
    });
    await ref
        .read(growControllerProvider.notifier)
        .getListGrowsDonatedOver(params);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var width = size.width;
    var height = size.height;
    List grows = ref.watch(growControllerProvider).growsDonatedOver;
    bool isMore = ref.watch(growControllerProvider).isMore;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          fetchData(configParams);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Dự án bạn gọi vốn đã qua',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              grows.isNotEmpty
                  ? SizedBox(
                      child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: grows.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, indexOwner) {
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
                                  grows[indexOwner]['banner'] != null
                                      ? grows[indexOwner]['banner']['url']
                                      : linkBannerDefault,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          GrowDetail(data: grows[indexOwner])));
                            },
                            textCard: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  right: 16.0,
                                  left: 16.0,
                                  top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      grows[indexOwner]['title'],
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w800,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      'Cam kết mục tiêu ${convertNumberToVND(grows[indexOwner]['target_value'] ~/ 1)} VNĐ',
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
                                      '${grows[indexOwner]['followers_count'].toString()} người quan tâm · ${grows[indexOwner]['backers_count'].toString()} người ủng hộ',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: greyColor,
                                        fontWeight: FontWeight.w700,
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
              isLoading && grows.isEmpty || isMore == true
                  ? const Center(child: CupertinoActivityIndicator())
                  : grows.isEmpty
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
                      : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
