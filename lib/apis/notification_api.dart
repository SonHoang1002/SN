import 'package:social_network_app_mobile/apis/api_root.dart';

class NotificationsApi {
  Future getListNotifications(params) async {
    return await Api().getRequestBase('/api/v1/notifications', params);
  }

  Future markNotiAsRead(notificationId) async {
    return await Api()
        .postRequestBase('/api/v1/notifications/$notificationId/read', null);
  }
}
