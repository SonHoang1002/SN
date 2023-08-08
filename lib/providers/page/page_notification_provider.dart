// ignore_for_file: non_constant_identifier_names
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';

class PageNotificationState {
  bool global_notifications;
  bool allow_notifications;
  bool allow_email_notifications;
  bool allow_sms_notifications;
  bool new_message;
  bool new_page_checkin;
  bool new_page_mention;
  bool new_page_review;
  bool new_post_comment;
  bool new_like;
  bool new_like_on_page_post;
  bool new_subscribers_to_event;
  bool new_followers_of_page;

  PageNotificationState({
    this.global_notifications = true,
    this.allow_notifications = true,
    this.allow_email_notifications = true,
    this.allow_sms_notifications = true,
    this.new_message = true,
    this.new_page_checkin = true,
    this.new_page_mention = true,
    this.new_page_review = true,
    this.new_post_comment = true,
    this.new_like = true,
    this.new_like_on_page_post = true,
    this.new_subscribers_to_event = true,
    this.new_followers_of_page = true,
  });

  PageNotificationState copyWith({
    bool global_notifications = true,
    bool allow_notifications = true,
    bool allow_email_notifications = true,
    bool allow_sms_notifications = true,
    bool new_message = true,
    bool new_page_checkin = true,
    bool new_page_mention = true,
    bool new_page_review = true,
    bool new_post_comment = true,
    bool new_like = true,
    bool new_like_on_page_post = true,
    bool new_subscribers_to_event = true,
    bool new_followers_of_page = true,
  }) {
    return PageNotificationState(
      global_notifications: global_notifications,
      allow_notifications: allow_notifications,
      allow_email_notifications: allow_email_notifications,
      allow_sms_notifications: allow_sms_notifications,
      new_message: new_message,
      new_page_checkin: new_page_checkin,
      new_page_mention: new_page_mention,
      new_page_review: new_page_review,
      new_post_comment: new_post_comment,
      new_like: new_like,
      new_like_on_page_post: new_like_on_page_post,
      new_subscribers_to_event: new_subscribers_to_event,
      new_followers_of_page: new_followers_of_page,
    );
  }
}

final pageNotificationsControllerProvider =
    StateNotifierProvider<PageNotificationsController, PageNotificationState>(
        (ref) {
  return PageNotificationsController();
});

class PageNotificationsController extends StateNotifier<PageNotificationState> {
  PageNotificationsController() : super(PageNotificationState());

  getNotificationsPage(id) async {
    var response = await PageApi().getNotificationsPageApi(id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
          global_notifications: response["global_notifications"],
          allow_notifications: response["allow_notifications"],
          allow_email_notifications: response["allow_email_notifications"],
          allow_sms_notifications: response["allow_sms_notifications"],
          new_message: response["new_message"],
          new_page_checkin: response["new_page_checkin"],
          new_page_mention: response["new_page_mention"],
          new_page_review: response["new_page_review"],
          new_post_comment: response["new_post_comment"],
          new_like: response["new_like"],
          new_like_on_page_post: response["new_like_on_page_post"],
          new_subscribers_to_event: response["new_subscribers_to_event"],
          new_followers_of_page: response["new_followers_of_page"],
        );
      }
    }
  }
}
