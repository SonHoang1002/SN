import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/events_api.dart';

@immutable
class EventState {
  final List events;
  final List posts;
  final List eventsOwner;
  final List groupSuggest;
  final List eventHosts;
  final dynamic eventDetail;
  final List eventsInvite;
  final List eventsInviteHost;
  final bool isMore;
  final List hosts;
  final List eventsSuggested;

  const EventState({
    this.events = const [],
    this.posts = const [],
    this.groupSuggest = const [],
    this.eventDetail = const {},
    this.eventsInvite = const [],
    this.eventHosts = const [],
    this.eventsInviteHost = const [],
    this.eventsOwner = const [],
    this.isMore = true,
    this.hosts = const [],
    this.eventsSuggested = const [],
  });

  EventState copyWith({
    List events = const [],
    List posts = const [],
    List groupSuggest = const [],
    List eventsOwner = const [],
    List eventHosts = const [],
    List eventsInvite = const [],
    List eventsInviteHost = const [],
    dynamic eventDetail = const {},
    bool isMore = true,
    List hosts = const [],
    List eventsSuggested = const [],
  }) {
    return EventState(
      events: events,
      posts: posts,
      eventDetail: eventDetail,
      groupSuggest: groupSuggest,
      eventHosts: eventHosts,
      eventsInvite: eventsInvite,
      eventsInviteHost: eventsInviteHost,
      eventsOwner: eventsOwner,
      isMore: isMore,
      hosts: hosts,
      eventsSuggested: eventsSuggested,
    );
  }
}

final eventControllerProvider =
    StateNotifierProvider.autoDispose<EventController, EventState>((ref) {
  return EventController();
});

class EventController extends StateNotifier<EventState> {
  EventController() : super(const EventState());

  getListEvent(params) async {
    List response = await EventApi().getEventSuggestedApi(params);
    if (response.isNotEmpty) {
      final newEvents =
          response.where((item) => !state.events.contains(item)).toList();
      state = state.copyWith(
          events: params.containsKey('max_id')
              ? [...state.events, ...newEvents]
              : newEvents,
          isMore: response.length < params['limit'] ? false : true,
          hosts: state.hosts,
          groupSuggest: state.groupSuggest,
          posts: state.posts,
          eventsOwner: state.eventsOwner,
          eventDetail: state.eventDetail,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventHosts: state.eventHosts,
          eventsSuggested: state.eventsSuggested);
    } else {
      final newEvents =
          response.where((item) => !state.events.contains(item)).toList();
      state = state.copyWith(
          isMore: false,
          hosts: state.hosts,
          posts: state.posts,
          groupSuggest: state.groupSuggest,
          eventDetail: state.eventDetail,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventsSuggested: state.eventsSuggested,
          eventHosts: state.eventHosts,
          events: params.containsKey('max_id')
              ? [...state.events, ...newEvents]
              : newEvents,
          eventsOwner: state.eventsOwner);
    }
  }

  getListEventOwner(params) async {
    List response = await EventApi().getListEventApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          eventsOwner: [...response],
          events: state.events,
          posts: state.posts,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          eventHosts: state.eventHosts,
          eventsInviteHost: state.eventsInviteHost,
          eventDetail: state.eventDetail,
          isMore: response.length < params['limit'] ? false : true,
          hosts: state.hosts,
          eventsSuggested: state.eventsSuggested);
    } else {
      state = state.copyWith(
          eventsOwner: [...response],
          events: state.events,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          posts: state.posts,
          eventsInviteHost: state.eventsInviteHost,
          eventDetail: state.eventDetail,
          eventHosts: state.eventHosts,
          isMore: false,
          hosts: state.hosts,
          eventsSuggested: state.eventsSuggested);
    }
  }

  getListInvite(params) async {
    var response = await EventApi().getListEventInviteApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          eventsInvite: [...response['data']],
          eventsOwner: state.eventsOwner,
          posts: state.posts,
          events: state.events,
          groupSuggest: state.groupSuggest,
          eventsInviteHost: state.eventsInviteHost,
          eventDetail: state.eventDetail,
          eventHosts: state.eventHosts,
          hosts: state.hosts,
          isMore: state.isMore,
          eventsSuggested: state.eventsSuggested);
    }
  }

  getListInviteHost() async {
    var response = await EventApi().getListEventInviteHostsApi();
    if (response.isNotEmpty) {
      state = state.copyWith(
          eventsInviteHost: [...response['data']],
          eventsOwner: state.eventsOwner,
          events: state.events,
          posts: state.posts,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          eventHosts: state.eventHosts,
          eventDetail: state.eventDetail,
          isMore: state.isMore,
          hosts: state.hosts,
          eventsSuggested: state.eventsSuggested);
    }
  }

  getDetailEvent(id) async {
    var response = await EventApi().getEventDetailApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
          eventDetail: response,
          events: state.events,
          posts: state.posts,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventsOwner: state.eventsOwner,
          eventHosts: state.eventHosts,
          hosts: state.hosts,
          isMore: state.isMore,
          eventsSuggested: state.eventsSuggested);
    }
  }

  getPostEvent(id, params) async {
    var response = await EventApi().getListPostEventApi(id, params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          posts: response,
          eventDetail: state.eventDetail,
          events: state.events,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventsOwner: state.eventsOwner,
          eventHosts: state.eventHosts,
          hosts: state.hosts,
          isMore: state.isMore,
          eventsSuggested: state.eventsSuggested);
    }
  }

  sendInviteEvents(id, data) async {
    List response = await EventApi().sendInvitationFriendEventApi(id, data);
    if (response.isNotEmpty) {
      state = state.copyWith(
          events: state.events,
          posts: state.posts,
          groupSuggest: state.groupSuggest,
          eventHosts: state.eventHosts,
          eventDetail: state.eventDetail,
          hosts: state.hosts,
          eventsSuggested: state.eventsSuggested);
    }
  }

  getListEventSuggested(params) async {
    List response = await EventApi().getEventSuggestedApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          eventsSuggested: [...response],
          events: state.events,
          posts: state.posts,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          eventHosts: state.eventHosts,
          eventsInviteHost: state.eventsInviteHost,
          eventDetail: state.eventDetail,
          eventsOwner: state.eventsOwner,
          hosts: state.hosts);
    }
  }

  getListGroupSuggested(params) async {
    List response = await EventApi().getGroupSuggestedApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          groupSuggest: [...response],
          eventsSuggested: state.eventsSuggested,
          events: state.events,
          posts: state.posts,
          eventsInvite: state.eventsInvite,
          eventHosts: state.eventHosts,
          eventsInviteHost: state.eventsInviteHost,
          eventDetail: state.eventDetail,
          eventsOwner: state.eventsOwner,
          hosts: state.hosts);
    }
  }

  getEventHosts(id) async {
    List response = await EventApi().getEventHostApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
          hosts: [...response],
          events: state.events,
          posts: state.posts,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventHosts: state.eventHosts,
          eventDetail: state.eventDetail,
          eventsOwner: state.eventsOwner,
          eventsSuggested: state.eventsSuggested);
    }
  }

  getListEventHosts(params) async {
    List response = await EventApi().getListEventApi(params);
    if (response.isNotEmpty) {
      final newListEvent =
          response.where((item) => !state.eventHosts.contains(item)).toList();
      state = state.copyWith(
          eventHosts: params.containsKey('max_id')
              ? [...state.eventHosts, ...newListEvent]
              : newListEvent,
          eventsOwner: state.eventsOwner,
          posts: state.posts,
          events: state.events,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventDetail: state.eventDetail,
          isMore: response.length < params['limit'] ? false : true,
          hosts: state.hosts,
          eventsSuggested: state.eventsSuggested);
    } else {
      final newListEvent =
          response.where((item) => !state.eventHosts.contains(item)).toList();
      state = state.copyWith(
          eventHosts: params.containsKey('max_id')
              ? [...state.eventHosts, ...newListEvent]
              : newListEvent,
          eventsOwner: state.eventsOwner,
          posts: state.posts,
          events: state.events,
          groupSuggest: state.groupSuggest,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventDetail: state.eventDetail,
          isMore: false,
          hosts: state.hosts,
          eventsSuggested: state.eventsSuggested);
    }
  }

  updateStatusEvent(id, data) {
    EventApi().statusEventApi(id, data);
    final index =
        state.events.indexWhere((element) => element['id'] == id.toString());
    final event = state.events[index];
    final updatedEvent = {
      ...event,
      'event_relationship': {
        ...event['event_relationship'],
        'status': data['status'] ?? '',
      },
    };
    state = state.copyWith(
      events: [
        ...state.events.sublist(0, index),
        updatedEvent,
        ...state.events.sublist(index + 1),
      ],
      hosts: state.hosts,
      eventsOwner: state.eventsOwner,
      posts: state.posts,
      groupSuggest: state.groupSuggest,
      eventHosts: state.eventHosts,
      eventDetail: state.eventDetail,
      eventsInvite: state.eventsInvite,
      eventsInviteHost: state.eventsInviteHost,
      eventsSuggested: state.eventsSuggested,
    );
  }

  void updateStatusEventDetail(id, data) {
    EventApi().statusEventApi(id, data);
    state = state.copyWith(
        events: state.events,
        posts: state.posts,
        hosts: state.hosts,
        groupSuggest: state.groupSuggest,
        eventsOwner: state.eventsOwner,
        eventHosts: state.eventHosts,
        eventDetail: {
          ...state.eventDetail,
          "event_relationship": {
            ...state.eventDetail["event_relationship"],
            "status": data["status"]
          }
        },
        eventsSuggested: state.eventsSuggested);
  }

  void updateStatusEventSuggested(id, data) {
    EventApi().statusEventApi(id, data);
    final index = state.eventsSuggested
        .indexWhere((element) => element['id'] == id.toString());
    final eventsSuggested = state.eventsSuggested[index];
    final updatedEvent = {
      ...eventsSuggested,
      'event_relationship': {
        ...eventsSuggested['event_relationship'],
        'status': data['status'] ?? '',
      },
    };
    state = state.copyWith(
      eventsSuggested: [
        ...state.eventsSuggested.sublist(0, index),
        updatedEvent,
        ...state.eventsSuggested.sublist(index + 1),
      ],
      hosts: state.hosts,
      posts: state.posts,
      groupSuggest: state.groupSuggest,
      eventsInvite: state.eventsInvite,
      eventHosts: state.eventHosts,
      eventsInviteHost: state.eventsInviteHost,
      eventsOwner: state.eventsOwner,
      eventDetail: state.eventDetail,
      events: state.events,
    );
  }

  void updateStatusInviteHost(id, data) {
    EventApi().statusEventHostInviteApi(id, data);
    final index = state.eventsInviteHost
        .indexWhere((element) => element['event']['id'] == id.toString());
    final eventsInviteHost = state.eventsInviteHost[index];
    final updatedEvent = {
      ...eventsInviteHost,
      'status': data['status'] ?? '',
    };
    state = state.copyWith(
      eventsInviteHost: [
        ...state.eventsInviteHost.sublist(0, index),
        updatedEvent,
        ...state.eventsInviteHost.sublist(index + 1),
      ],
      hosts: state.hosts,
      eventsInvite: state.eventsInvite,
      posts: state.posts,
      groupSuggest: state.groupSuggest,
      eventsSuggested: state.eventsSuggested,
      eventHosts: state.eventHosts,
      eventsOwner: state.eventsOwner,
      eventDetail: state.eventDetail,
      events: state.events,
    );
  }

  void updateStatusInvite(id, data) {
    EventApi().statusEventHostInviteApi(id, data);
    final index = state.eventsInvite
        .indexWhere((element) => element['event']['id'] == id.toString());
    final eventsInvite = state.eventsInvite[index];
    final updatedEvent = {
      ...eventsInvite,
      'event_relationship': {
        ...eventsInvite['event_relationship'],
        'status': data['status'] ?? '',
      },
    };
    state = state.copyWith(
      eventsInvite: [
        ...state.eventsInvite.sublist(0, index),
        updatedEvent,
        ...state.eventsInvite.sublist(index + 1),
      ],
      hosts: state.hosts,
      posts: state.posts,
      eventsInviteHost: state.eventsInviteHost,
      eventHosts: state.eventHosts,
      groupSuggest: state.groupSuggest,
      eventsSuggested: state.eventsSuggested,
      eventsOwner: state.eventsOwner,
      eventDetail: state.eventDetail,
      events: state.events,
    );
  }

  void updateStatusEvents(id, data) {
    EventApi().statusEventApi(id, data);
    final index = state.eventsOwner
        .indexWhere((element) => element['id'] == id.toString());
    final eventsOwner = state.eventsOwner[index];
    final updatedEvent = {
      ...eventsOwner,
      'event_relationship': {
        ...eventsOwner['event_relationship'],
        'status': data['status'] ?? '',
      },
    };
    state = state.copyWith(
      eventsOwner: [
        ...state.eventsOwner.sublist(0, index),
        updatedEvent,
        ...state.eventsOwner.sublist(index + 1),
      ],
      hosts: state.hosts,
      posts: state.posts,
      eventsSuggested: state.eventsSuggested,
      eventsInvite: state.eventsInvite,
      groupSuggest: state.groupSuggest,
      eventHosts: state.eventHosts,
      eventsInviteHost: state.eventsInviteHost,
      eventDetail: state.eventDetail,
      events: state.events,
    );
  }

  refreshListEvent(params) async {
    List response = await EventApi().getListEventApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          events: response,
          isMore: response.length < params['limit'] ? false : true,
          hosts: state.hosts,
          groupSuggest: state.groupSuggest,
          posts: state.posts,
          eventsOwner: state.eventsOwner,
          eventDetail: state.eventDetail,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventHosts: state.eventHosts,
          eventsSuggested: state.eventsSuggested);
    } else {
      state = state.copyWith(
          isMore: false,
          hosts: state.hosts,
          posts: state.posts,
          groupSuggest: state.groupSuggest,
          eventDetail: state.eventDetail,
          eventsInvite: state.eventsInvite,
          eventsInviteHost: state.eventsInviteHost,
          eventsSuggested: state.eventsSuggested,
          eventHosts: state.eventHosts,
          events: response,
          eventsOwner: state.eventsOwner);
    }
  }
}
