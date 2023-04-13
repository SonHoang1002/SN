import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/learn_space_api.dart';

@immutable
class LearnSpaceState {
  final List course;
  final List coursePropose;
  final List courseSimilar;
  final bool isMore;
  final dynamic detailCourse;

  const LearnSpaceState({
    this.course = const [],
    this.isMore = true,
    this.coursePropose = const [],
    this.detailCourse = const {},
    this.courseSimilar = const [],
  });

  LearnSpaceState copyWith({
    List course = const [],
    List coursePropose = const [],
    bool isMore = true,
    dynamic detailCourse = const {},
    List courseSimilar = const [],
  }) {
    return LearnSpaceState(
      course: course,
      isMore: isMore,
      coursePropose: coursePropose,
      detailCourse: detailCourse,
      courseSimilar: courseSimilar,
    );
  }
}

final learnSpaceStateControllerProvider =
    StateNotifierProvider.autoDispose<LearnSpaceController, LearnSpaceState>(
        (ref) => LearnSpaceController());

class LearnSpaceController extends StateNotifier<LearnSpaceState> {
  LearnSpaceController() : super(const LearnSpaceState());

  getListCourses(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.course.contains(item)).toList();
      state = state.copyWith(
          course: params.containsKey('max_id')
              ? [...state.course, ...newGrows]
              : newGrows,
          isMore: params['limit'] != null
              ? response.length < params['limit'] || response.isEmpty
                  ? false
                  : true
              : false,
          detailCourse: state.detailCourse,
          coursePropose: state.coursePropose,
          courseSimilar: state.courseSimilar);
    } else {
      final newGrows =
          response.where((item) => !state.course.contains(item)).toList();
      state = state.copyWith(
          course: params.containsKey('max_id')
              ? [...state.course, ...newGrows]
              : newGrows,
          isMore: false,
          detailCourse: state.detailCourse,
          coursePropose: state.coursePropose,
          courseSimilar: state.courseSimilar);
    }
  }

  getDetailCourses(id) async {
    dynamic response = await LearnSpaceApi().getDetailCoursesApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
          course: state.course,
          isMore: state.isMore,
          detailCourse: response,
          coursePropose: state.coursePropose,
          courseSimilar: state.courseSimilar);
    }
  }

  getListCoursesPropose(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          course: state.course,
          detailCourse: state.detailCourse,
          coursePropose: response,
          isMore: state.isMore,
          courseSimilar: state.courseSimilar);
    }
  }

  getListCoursesSimilar(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          course: state.course,
          detailCourse: state.detailCourse,
          isMore: state.isMore,
          coursePropose: state.coursePropose,
          courseSimilar: response);
    }
  }
}
