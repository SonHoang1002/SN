import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/events_api.dart';

@immutable
class EventState {
  final List events;
  final List eventsOwner;
  final dynamic eventDetail;
  final bool isMore;
  final List hosts;
  final List eventsSuggested;

  const EventState({
    this.events = const [],
    this.eventDetail = const {},
    this.eventsOwner = const [],
    this.isMore = true,
    this.hosts = const [],
    this.eventsSuggested = const [],
  });

  EventState copyWith({
    List events = const [],
    List eventsOwner = const [],
    dynamic eventDetail = const {},
    bool isMore = true,
    List hosts = const [],
    List eventsSuggested = const [],
  }) {
    return EventState(
      events: events,
      eventDetail: eventDetail,
      eventsOwner: eventsOwner,
      isMore: isMore,
      hosts: hosts,
      eventsSuggested: eventsSuggested,
    );
  }
}

final eventControllerProvider =
    StateNotifierProvider<EventController, EventState>(
        (ref) => EventController());

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
          eventsOwner: state.eventsOwner,
          eventDetail: state.eventDetail,
          eventsSuggested: state.eventsSuggested);
    } else {
      final newEvents =
      response.where((item) => !state.events.contains(item)).toList();
      state = state.copyWith(
          isMore: false,
          hosts: state.hosts,
          eventDetail: state.eventDetail,
          eventsSuggested: state.eventsSuggested,
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
          eventDetail: state.eventDetail,
          isMore: response.length < params['limit'] ? false : true,
          hosts: state.hosts,
          eventsSuggested: state.eventsSuggested);
    }
  }
  getDetailEvent(id) async {
    var response = await EventApi().getEventDetailApi(id);
    print(response);
    if (response.isNotEmpty) {
      state = state.copyWith(
          eventDetail: response,
          events: state.events,
          eventsOwner: state.eventsOwner,
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
          eventDetail: state.eventDetail,
          eventsOwner: state.eventsOwner,
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
        eventsOwner: state.eventsOwner,
        eventDetail: state.eventDetail,
        eventsSuggested: state.eventsSuggested);
  }
  updateOwnerStatusEvent(id, data) async {
    var res = await EventApi().statusEventApi(id, data);
    var indexEventUpdate =
    state.eventsOwner.indexWhere((element) => element['id'] == id.toString());
    var eventUpdate = state.eventsOwner[indexEventUpdate];
    eventUpdate['event_relationship']['status'] = res['status'] ?? '';
    state = state.copyWith(
        eventsOwner: state.eventsOwner.sublist(0, indexEventUpdate) +
            [eventUpdate] +
            state.eventsOwner.sublist(indexEventUpdate + 1),
        hosts: state.hosts,
        events: state.events,
        eventDetail: state.eventDetail,
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
