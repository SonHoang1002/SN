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

  updateStatusEvent(id, data) {
    EventApi().statusEventApi(id, data);
    final index = state.events.indexWhere((element) => element['id'] == id.toString());
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
      eventDetail: state.eventDetail,
      eventsSuggested: state.eventsSuggested,
    );
  }
  void updateStatusEventDetail(id, data) {
     EventApi().statusEventApi(id, data);
    state = state.copyWith(
        events: state.events,
        hosts: state.hosts,
        eventsOwner: state.eventsOwner,
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
    final index = state.eventsSuggested.indexWhere((element) => element['id'] == id.toString());
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
      eventsOwner: state.eventsOwner,
      eventDetail: state.eventDetail,
      events: state.events,
    );
  }
  void updateStatusEvents(id, data) {
    EventApi().statusEventApi(id, data);
    final index = state.eventsOwner.indexWhere((element) => element['id'] == id.toString());
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
      eventsSuggested: state.eventsSuggested,
      eventDetail: state.eventDetail,
      events: state.events,
    );
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
