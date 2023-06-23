import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/notification_api.dart';

@immutable
class NotificationState {
  final List notifications;
  final bool isMore;

  const NotificationState({
    this.notifications = const [],
    this.isMore = true,
  });

  NotificationState copyWith({
    List notifications = const [],
    bool isMore = true,
  }) {
    return NotificationState(
      notifications: notifications,
      isMore: isMore,
    );
  }
}

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
  return NotificationController();
});

class NotificationController extends StateNotifier<NotificationState> {
  NotificationController() : super(const NotificationState());

  getListNotifications(params) async {
    List response = await NotificationsApi().getListNotifications(params);
    if (response.isNotEmpty) {
      final newList = response
          .where((item) => !state.notifications.contains(item))
          .toList();
      state = state.copyWith(
        notifications: params != null
            ? params.containsKey('max_id')
                ? [...state.notifications, ...newList]
                : newList
            : newList,
        isMore: params != null
            ? params.containsKey('max_id')
                ? true
                : false
            : false,
      );
    } else {
      final newList = response
          .where((item) => !state.notifications.contains(item))
          .toList();
      state = state.copyWith(
        notifications: params != null
            ? params.containsKey('max_id')
                ? [...state.notifications, ...newList]
                : newList
            : newList,
        isMore: false,
      );
    }
  }

  markNotificationIdAsRead(notiId) async {
    int index = state.notifications.indexWhere((e) => e['id'] == notiId);
    if (state.notifications[index]['read'] == false) {
      NotificationsApi().markNotiAsRead(notiId);
      state = state.copyWith(
        isMore: state.isMore,
        notifications: state.notifications.map((ele) {
          if (ele['id'] == notiId) {
            ele['read'] = true;
          }
        }).toList(),
      );
    }
  }
}
