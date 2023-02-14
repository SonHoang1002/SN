import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/events_api.dart';

@immutable
class EventState {
  final List events;
  final bool isMore;
  final List hosts;
  final List eventsSuggested;
  final List friendExcludes;
  final List friendIncludes;

  const EventState({
    this.events = const [],
    this.isMore = true,
    this.hosts = const [],
    this.eventsSuggested = const [],
    this.friendExcludes = const [],
    this.friendIncludes = const [],
  });

  EventState copyWith({
    List events = const [],
    bool isMore = true,
    List hosts = const [],
    List eventsSuggested = const [],
    List friendExcludes = const [],
    List friendIncludes = const [],
  }) {
    return EventState(
      events: events,
      isMore: isMore,
      hosts: hosts,
      eventsSuggested: eventsSuggested,
      friendExcludes: friendExcludes,
      friendIncludes: friendIncludes,
    );
  }
}

final eventControllerProvider =
    StateNotifierProvider<EventController, EventState>(
        (ref) => EventController());

class EventController extends StateNotifier<EventState> {
  EventController() : super(const EventState());

  getListEvent(params) async {
    List response = await EventApi().getListEventApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          events: [...response],
          isMore: response.length < params['limit'] ? false : true,
          hosts: state.hosts,
          friendExcludes: state.friendExcludes,
          friendIncludes: state.friendIncludes,
          eventsSuggested: state.eventsSuggested);
    } else {
      state = state.copyWith(isMore: false);
    }
  }

  getListFriendExcludes(params) async {
    var response = await EventApi().getListFriendExcludesApi(params);
    if (response['data'].isNotEmpty) {
      state = state.copyWith(
          friendExcludes: [...response['data']],
          events: state.events,
          hosts: state.hosts,
          eventsSuggested: state.eventsSuggested);
    } else {
      state = state.copyWith(isMore: false);
    }
  }

  getListEventSuggested(params) async {
    List response = await EventApi().getEventSuggestedApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          eventsSuggested: [...response],
          events: state.events,
          hosts: state.hosts);
    } else {
      state = state.copyWith(
          isMore: false, events: state.events, hosts: state.hosts);
    }
  }

  getEventHosts(id) async {
    List response = await EventApi().getEventHostApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
          hosts: [...response],
          events: state.events,
          eventsSuggested: state.eventsSuggested);
    } else {
      state = state.copyWith(
          isMore: false,
          events: state.events,
          eventsSuggested: state.eventsSuggested);
    }
  }

  updateStatusEvent(id, data) async {
    var res = await EventApi().statusEventApi(id, data);
    var indexEventUpdate =
        state.events.indexWhere((element) => element['id'] == id.toString());
    var eventUpdate = state.events[indexEventUpdate];
    eventUpdate['event_relationship']['status'] = res['status'] ?? '';
    state = state.copyWith(
        events: state.events.sublist(0, indexEventUpdate) +
            [eventUpdate] +
            state.events.sublist(indexEventUpdate + 1),
        hosts: state.hosts,
        eventsSuggested: state.eventsSuggested);
  }

  refreshListEvent(params) async {
    List response = await EventApi().getListEventApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          events: response,
          isMore: response.length < params['limit'] ? false : true);
    } else {
      state = state.copyWith(isMore: false);
    }
  }
}
