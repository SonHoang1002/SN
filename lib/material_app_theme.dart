import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/notification/notification_provider.dart';
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/services/notification_service.dart';
import 'package:social_network_app_mobile/services/web_socket_service.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'home/PreviewScreen.dart';
import 'home/home.dart';
import 'screens/Login/LoginCreateModules/onboarding_login_page.dart';
import 'screens/Page/PageDetail/page_detail.dart';
import 'screens/UserPage/user_page.dart';
import 'theme/theme_manager.dart';

var routes = <String, WidgetBuilder>{
  '/home': (BuildContext context) => const Home(),
  '/page': (BuildContext context) => const PageDetail(),
  '/user': (BuildContext context) => const UserPageHome(),
  //  SaleInformationMarketPage
  // '/login': (BuildContext context) => const OnboardingLoginPage(),
  '/': (BuildContext context) => const PreviewScreen(),
};

class MaterialAppWithTheme extends ConsumerStatefulWidget {
  const MaterialAppWithTheme({
    super.key,
  });

  @override
  ConsumerState<MaterialAppWithTheme> createState() =>
      _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends ConsumerState<MaterialAppWithTheme> {
  late WebSocketChannel webSocketChannel;
  StreamSubscription<dynamic>? subscription;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero, () => fetchNotifications(null));
    connectToWebSocket();
  }

  void connectToWebSocket() async {
    webSocketChannel = await WebSocketService().connectToWebSocket();
    listenToWebSocket();
  }

  void listenToWebSocket() {
    subscription = webSocketChannel.stream.listen(
      (data) {
        if (data.contains('42')) {
          // 42["unseen_count_changed",{"id":"891993","transactionId":"891993","unseenCount":3817}]
          // 42["unseen_count_changed",{"id":"891633","unseenCount":3817}]
          int startIndex = data.indexOf('[') + 1;
          int endIndex = data.lastIndexOf(']');
          String jsonString = data.substring(startIndex, endIndex);
          List<dynamic> dataList = jsonDecode("[$jsonString]");
          Map<String, dynamic> object = dataList[1];
          if (data.contains('transactionId')) {
            fetchNotifications(null).then((value) async {
              dynamic dataFilter = ref
                  .read(notificationControllerProvider)
                  .notifications
                  .where((element) => element['id'] == object['id'])
                  .toList();
              if (dataFilter != null && dataFilter.isNotEmpty) {
                await NotificationService().showNotification(
                    title: 'EMSO',
                    payLoad: jsonEncode(dataFilter),
                    largeIcon: dataFilter[0]['account']['avatar_media'] != null
                        ? dataFilter[0]['account']['avatar_media']
                            ['preview_url']
                        : dataFilter[0]['account']['avatar_static'],
                    body:
                        '${renderName(dataFilter)}${renderContent(dataFilter)['textNone'] ?? ''} ${renderContent(dataFilter)['textBold'] ?? ''}');
              }
            });
          }
        }
      },
      onDone: () {
        print('WebSocket closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
  }

  void cancelListening() {
    webSocketChannel.sink.close();
  }

  dynamic renderContent(noti) {
    dynamic status = noti[0]['status'] ?? {};
    String type = noti[0]['type'];

    if (type == 'folow') {
      return {'textNone': ' đã theo dõi bạn'};
    } else if (type == 'reblog') {
      return {'textNone': ' đã chia sẻ bài viết của bạn'};
    } else if (type == 'mention') {
      return {'textNone': ' đã nhắc đến bạn trong một bài viết'};
    } else if (type == 'poll') {
      return {'textNone': ' đã bầu chọn trong cuộc thăm dò của bạn'};
    } else if (type == 'friendship_request') {
      return {'textNone': ' đã gửi cho bạn lời mời kết bạn'};
    } else if (type == 'event_invitation') {
      return {'textNone': ' đã gửi cho bạn lời mời tham gia sự kiện'};
    } else if (type == 'event_invitation_host') {
      return {'textNone': ' đã mời bạn đồng tổ chức sự kiện:'};
    } else if (type == 'page_follow') {
      return {'textNone': ' đã thích'};
    } else if (type == 'page_invitation') {
      return {'textNone': ' đã mời bạn làm quản trị viên '};
    } else if (type == 'page_invitation_follow') {
      return {'textNone': ' đã mời bạn thích trang'};
    } else if (type == 'group_invitation') {
      return {'textNone': ' đã mời bạn tham gia nhóm'};
    } else if (type == 'accept_event_invitation') {
      return {'textNone': ' đã đồng ý tham gia sự kiện'};
    } else if (type == 'accept_event_invitation_host') {
      return {'textNone': ' đã đồng ý đồng tổ chức sự kiện'};
    } else if (type == 'accept_page_invitation') {
      return {'textNone': ' đã đồng ý làm quản trị viên trang'};
    } else if (type == 'accept_page_invitation_follow') {
      return {'textNone': ' đã chấp nhận lời mời thích trang'};
    } else if (type == 'accept_group_invitation') {
      return {'textNone': ' đã chấp nhận lời mời tham gia nhóm'};
    } else if (type == 'accept_friendship_request') {
      return {'textNone': ' đã chấp nhận lời mời kết bạn'};
    } else if (type == 'group_join_request') {
      return {'textNone': ' đã yêu cầu tham gia'};
    } else if (type == 'created_status') {
      return {
        'textNone': ' Video của bạn đã sẵn sàng.Bây giờ bạn có thể mở xem'
      };
    } else if (type == 'status_tag') {
      return {
        'textNone': status['in_reply_to_parent_id'] != null ||
                status['in_reply_to_id'] != null
            ? ' đã nhắc đến bạn trong một bình luận'
            : ' đã gắn thẻ bạn trong một bài viết'
      };
    } else if (type == 'comment') {
      return {
        'textNone':
            ' đã bình luận về một bài viết có thể bạn quan tâm: ${status['content']}'
      };
    } else if (type == 'approved_group_join_request') {
      return {
        'textNone':
            ' Quản trị viên đã phê duyệt yêu cầu tham gia của bạn. Chào mừng bạn đến với'
      };
    } else if (type == 'course_invitation') {
      return {'textNone': ' đã mời bạn tham gia khóa học'};
    } else if (type == 'product_invitation') {
      return {'textNone': ' đã mời bạn quan tâm đến sản phẩm'};
    } else if (type == 'admin_page_invitation') {
      return {
        'textNone': ' đã mời bạn làm quản trị viên',
        'textBold': '${status?['page']?['title']}'
      };
    } else if (type == 'approved_group_status') {
      return {
        'textNone':
            '  bài viết của bạn tại ${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']} đã được phê duyệt',
      };
    } else if (type == 'accept_admin_page_invitation') {
      return {
        'textNone': ' đã đồng ý làm quản trị viên trang',
        'textBold': '${status?['page']?['title']}'
      };
    } else if (type == 'recruit_apply') {
      return {
        'textNone': ' đã ứng tuyển vào công việc',
        'textBold': '${status?['recruit']?['title']}'
      };
    } else if (type == 'recruit_invitation') {
      return {
        'textNone': ' đã mời bạn tham gia tuyển dụng',
        'textBold': '${status?['recruit']?['title']}'
      };
    } else if (type == 'moderator_page_invitation') {
      return {
        'textNone': ' đã đồng ý làm kiểm duyệt viên trang',
        'textBold': '${status?['page']?['title']}'
      };
    }
    if (type == 'favourite') {
      return {
        'textNone':
            ' đã bày tỏ cảm xúc về ${status['in_reply_to_parent_id'] != null || status['in_reply_to_id'] != null ? 'bình luận' : 'bài viết'} ${status['page_owner'] == null && status['account']?['id'] == ref.watch(meControllerProvider)[0]['id'] ? 'của bạn' : ''} ${status['content'] ?? ""}'
      };
    } else if (type == 'status') {
      if (status['reblog'] != null) {
        return {
          'textNone':
              ' đã chia sẻ một bài viết ${status['reblog']?['page'] != null || status['reblog']?['group'] != null ? 'trong' : ''}'
        };
      } else if (status['page_owner'] != null) {
        return {
          'textNone': status['post_type'] == 'event_shared}'
              ? ' đã tạo một sự kiện '
              : ' có một bài viết mới: ${status['content'] ?? ""}]} '
        };
      } else if (status['group'] != null || status['page'] != null) {
        if (noti[0]['account']['relationship'] != null &&
            noti[0]['account']['relationship']['friendship_status'] ==
                'ARE_FRIENDS') {
          return {
            'textNone': status['post_type'] == 'event_shared}'
                ? ' đã tạo một sự kiện trong '
                : ' có tạo bài viết trong ',
            'textBold': status['post_type'] == 'event_shared}'
                ? '${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']}'
                : '${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']}'
          };
        } else {
          return {
            'textNone': status['post_type'] == 'event_shared}'
                ? ' có sự kiện mới: ${status['content'] ?? ""}'
                : ' có bài viết mới: ${status['content'] ?? ""}'
          };
        }
      } else if (status['post_type'] == 'moment') {
        return {'textNone': ' đã đăng một khoảnh khắc mới'};
      } else if (status['post_type'] == 'watch') {
        return {'textNone': ' đã đăng một video mới trong watch'};
      } else if (status['post_type'] == 'question') {
        return {'textNone': ' đã đặt một câu hỏi'};
      } else if (status['post_type'] == 'target') {
        return {'textNone': ' đã đặt một mục tiêu mới'};
      } else {
        return {'textNone': ' đã tạo bài viết mới ${status['content'] ?? ""}'};
      }
    }
  }

  renderName(noti) {
    dynamic status = noti[0]['status'];
    dynamic account = noti[0]['account'];
    switch (noti[0]['type']) {
      case 'event_invitation_host':
        return status['event']?['page']?['title'] ?? account['display_name'];
      case 'status':
        return status['group']?['title'] ??
            status['page']?['title'] ??
            account['display_name'];

      default:
        return account['display_name'];
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    cancelListening();
    super.dispose();
  }

  fetchNotifications(params) async {
    await ref
        .read(notificationControllerProvider.notifier)
        .getListNotifications(params);
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    final selectedVideo = ref.watch(selectedVideoProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: theme.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            initialRoute: '/',
            routes: routes,
          ),
          if (selectedVideo != null)
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 100, right: 10, left: 10),
              child: SizedBox(
                // width: double.infinity,
                // height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Card(
                    elevation: 10,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          color: Color(int.parse(
                              '0xFF${selectedVideo['media_attachments'][0]['meta']['small']['average_color'].substring(1)}')),
                          child: Center(
                            child: VideoPlayerNoneController(
                              isShowVolumn: false,
                              media: selectedVideo['media_attachments'][0],
                              type: 'miniPlayer',
                              path: selectedVideo['media_attachments'][0]
                                  ['remote_url'],
                            ),
                          ),
                        ),
                        Flexible(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(left: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    selectedVideo['content'].isNotEmpty
                                        ? SizedBox(
                                            height: 20,
                                            width: 150,
                                            child: Marquee(
                                              text: selectedVideo['content'],
                                              velocity: 30,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : const SizedBox(),
                                    Flexible(
                                      child: Text(
                                        selectedVideo['account']
                                                ['display_name'] ??
                                            selectedVideo['page']['title'] ??
                                            '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      FontAwesomeIcons
                                          .upRightAndDownLeftFromCenter,
                                      size: 15),
                                  onPressed: () {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (GlobalVariable
                                              .navState.currentContext !=
                                          null) {
                                        MaterialPageRoute(
                                            builder: (context) => WatchDetail(
                                                  post: selectedVideo,
                                                  media: selectedVideo[
                                                      'media_attachments'][0],
                                                ));
                                      }
                                    });

                                    ref
                                        .read(selectedVideoProvider.notifier)
                                        .update((state) => null);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    ref
                                        .read(selectedVideoProvider.notifier)
                                        .update((state) => null);
                                  },
                                )
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void navigateToSecondPageByNameWithoutContext(routeName) {
  navigatorKey.currentState!.pushReplacementNamed(routeName);
}

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}
