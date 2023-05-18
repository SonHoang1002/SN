import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/notification/notification_provider.dart';
import 'package:social_network_app_mobile/service/notification_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'home/PreviewScreen.dart';
import 'home/home.dart';
import 'screen/Login/LoginCreateModules/onboarding_login_page.dart';
import 'screen/Page/PageDetail/page_detail.dart';
import 'screen/UserPage/user_page.dart';
import 'theme/theme_manager.dart';

var routes = <String, WidgetBuilder>{
  '/home': (BuildContext context) => const Home(),
  '/page': (BuildContext context) => const PageDetail(),
  '/user': (BuildContext context) => const UserPage(),
  //  SaleInformationMarketPage
  '/login': (BuildContext context) => const OnboardingLoginPage(),
  '/': (BuildContext context) => const PreviewScreen(),
};

class MaterialAppWithTheme extends ConsumerStatefulWidget {
  final WebSocketChannel webSocketChannel;
  const MaterialAppWithTheme({
    super.key,
    required this.webSocketChannel,
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
    webSocketChannel = widget.webSocketChannel;
    listenToWebSocket();
  }

  void listenToWebSocket() {
    subscription = webSocketChannel.stream.listen(
      (data) {
        if (data.contains('42')) {
          int startIndex = data.indexOf('[') + 1;
          int endIndex = data.lastIndexOf(']');
          String jsonString = data.substring(startIndex, endIndex);
          List<dynamic> dataList = jsonDecode("[$jsonString]");
          Map<String, dynamic> object = dataList[1];
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
                      ? dataFilter[0]['account']['avatar_media']['preview_url']
                      : dataFilter[0]['account']['avatar_static'],
                  body:
                      '${renderName(dataFilter)}${renderContent(dataFilter)['textNone'] ?? ''} ${renderContent(dataFilter)['textBold'] ?? ''}');
            }
          });
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

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: theme.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      initialRoute: '/',
      routes: routes,
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void navigateToSecondPageByNameWithoutContext(routeName) {
  navigatorKey.currentState!.pushReplacementNamed(routeName);
}
