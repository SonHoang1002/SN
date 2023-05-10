import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';

class GrowHost extends ConsumerStatefulWidget {
  const GrowHost({Key? key}) : super(key: key);

  @override
  ConsumerState<GrowHost> createState() => _GrowHostState();
}

class _GrowHostState extends ConsumerState<GrowHost> {
  String growHost = "now";
  bool loading = false;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero, () => _fetchGetListGrowHostNow());
  }

  void _fetchGetListGrowHostNow() async {
    setState(() {
      loading = true;
    });
    await ref
        .read(growControllerProvider.notifier)
        .getListGrowHostNow({"only_current_user": true, "time": "now"});
    setState(() {
      loading = false;
    });
  }

  void _fetchGetListGrowUpcoming() async {
    setState(() {
      loading = true;
    });
    await ref
        .read(growControllerProvider.notifier)
        .getListGrowUpcoming({"only_current_user": true, "time": "upcoming"});
    setState(() {
      loading = false;
    });
  }

  void _fetchGetListGrowPast() async {
    setState(() {
      loading = true;
    });
    await ref
        .read(growControllerProvider.notifier)
        .getListGrowPast({"only_current_user": true, "time": "past"});
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    List grows = ref.watch(growControllerProvider).growsHostNow;
    List growsUpcoming = ref.watch(growControllerProvider).growsUpcoming;
    List growsPast = ref.watch(growControllerProvider).growsPast;
    bool isMore = ref.watch(growControllerProvider).isMore;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          growHost == 'now'
              ? _fetchGetListGrowHostNow()
              : growHost == 'upcoming'
                  ? _fetchGetListGrowUpcoming()
                  : _fetchGetListGrowPast();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Dự án bạn tổ chức',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            growHost = 'now';
                            _fetchGetListGrowHostNow();
                          });
                        },
                        child: Container(
                          height: 38,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                              color: growHost == 'now'
                                  ? secondaryColor
                                  : const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Đang diễn ra',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: growHost == 'now'
                                        ? Colors.white
                                        : colorWord(context),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]),
                        )),
                    const SizedBox(width: 5),
                    InkWell(
                        onTap: () {
                          setState(() {
                            growHost = 'upcoming';
                            _fetchGetListGrowUpcoming();
                          });
                        },
                        child: Container(
                          height: 38,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                              color: growHost == 'upcoming'
                                  ? secondaryColor
                                  : const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sắp diễn ra',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: growHost == 'upcoming'
                                      ? Colors.white
                                      : colorWord(context),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(width: 5),
                    InkWell(
                        onTap: () {
                          setState(() {
                            growHost = 'past';
                            _fetchGetListGrowPast();
                          });
                        },
                        child: Container(
                          height: 38,
                          width: size.width * 0.3 - 5,
                          decoration: BoxDecoration(
                              color: growHost == 'past'
                                  ? secondaryColor
                                  : const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Trước đây',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: growHost == 'past'
                                      ? Colors.white
                                      : colorWord(context),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              growHost == 'now'
                  ? grows.isNotEmpty
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
                                imageCard: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: Hero(
                                    tag: grows[indexOwner]['id'] ?? "",
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
                                          builder: (context) => GrowDetail(
                                              data: grows[indexOwner])));
                                },
                                textCard: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                      right: 16.0,
                                      left: 16.0,
                                      top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0, top: 8.0),
                                        child: Text(
                                          grows[indexOwner]['status'] ==
                                                  'approved'
                                              ? 'Đã được duyệt'
                                              : grows[indexOwner]['status'] ==
                                                      'rejected'
                                                  ? 'Từ chối'
                                                  : 'Đang chờ',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: grows[indexOwner]
                                                        ['status'] ==
                                                    'approved'
                                                ? Colors.green
                                                : Colors.red,
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
                      : const SizedBox()
                  : growHost == 'upcoming'
                      ? growsUpcoming.isNotEmpty
                          ? SizedBox(
                              child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: growsUpcoming.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, indexUpcoming) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 8.0),
                                  child: CardComponents(
                                    imageCard: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: Hero(
                                        tag: growsUpcoming[indexUpcoming]
                                                ['id'] ??
                                            "",
                                        child: ExtendedImage.network(
                                          growsUpcoming[indexUpcoming]
                                                      ['banner'] !=
                                                  null
                                              ? growsUpcoming[indexUpcoming]
                                                  ['banner']['url']
                                              : linkBannerDefault,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => GrowDetail(
                                                  data: growsUpcoming[
                                                      indexUpcoming])));
                                    },
                                    textCard: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                          right: 16.0,
                                          left: 16.0,
                                          top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              growsUpcoming[indexUpcoming]
                                                  ['title'],
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
                                              'Cam kết mục tiêu ${convertNumberToVND(growsUpcoming[indexUpcoming]['target_value'] ~/ 1)} VNĐ',
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
                                              '${growsUpcoming[indexUpcoming]['followers_count'].toString()} người quan tâm · ${growsUpcoming[indexUpcoming]['backers_count'].toString()} người ủng hộ',
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0,
                                                right: 2.0,
                                                top: 8.0),
                                            child: Text(
                                              growsUpcoming[indexUpcoming]
                                                          ['status'] ==
                                                      'approved'
                                                  ? 'Đã được duyệt'
                                                  : growsUpcoming[indexUpcoming]
                                                              ['status'] ==
                                                          'rejected'
                                                      ? 'Từ chối'
                                                      : 'Đang chờ',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color:
                                                    growsUpcoming[indexUpcoming]
                                                                ['status'] ==
                                                            'approved'
                                                        ? Colors.green
                                                        : Colors.red,
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
                          : const SizedBox()
                      : growsPast.isNotEmpty
                          ? SizedBox(
                              child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: growsPast.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, indexPast) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 8.0),
                                  child: CardComponents(
                                    imageCard: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: Hero(
                                        tag: growsPast[indexPast]['id'] ?? "",
                                        child: ExtendedImage.network(
                                          growsPast[indexPast]['banner'] != null
                                              ? growsPast[indexPast]['banner']
                                                  ['url']
                                              : linkBannerDefault,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => GrowDetail(
                                                  data: growsPast[indexPast])));
                                    },
                                    textCard: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                          right: 16.0,
                                          left: 16.0,
                                          top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              growsPast[indexPast]['title'],
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
                                              'Cam kết mục tiêu ${convertNumberToVND(growsPast[indexPast]['target_value'] ~/ 1)} VNĐ',
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
                                              '${growsPast[indexPast]['followers_count'].toString()} người quan tâm · ${growsPast[indexPast]['backers_count'].toString()} người ủng hộ',
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0,
                                                right: 2.0,
                                                top: 8.0),
                                            child: Text(
                                              growsPast[indexPast]['status'] ==
                                                      'approved'
                                                  ? 'Đã được duyệt'
                                                  : growsPast[indexPast]
                                                              ['status'] ==
                                                          'rejected'
                                                      ? 'Từ chối'
                                                      : 'Đang chờ',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: growsPast[indexPast]
                                                            ['status'] ==
                                                        'approved'
                                                    ? Colors.green
                                                    : Colors.red,
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
              loading && growHost == 'upcoming' && growsUpcoming.isEmpty ||
                      growHost == 'now' && grows.isEmpty ||
                      growHost == 'past' && growsPast.isEmpty ||
                      isMore == true
                  ? const Center(child: CupertinoActivityIndicator())
                  : growHost == 'upcoming' && growsUpcoming.isEmpty ||
                          growHost == 'now' && grows.isEmpty ||
                          growHost == 'past' && growsPast.isEmpty
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
