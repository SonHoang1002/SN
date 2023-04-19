import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/learn_space_api.dart';

@immutable
class LearnSpaceState {
  final List course;
  final List courseInvitations;
  final List coursePropose;
  final List courseSimilar;
  final bool isMore;
  final List courseLibrary;
  final dynamic detailCourse;

  const LearnSpaceState({
    this.course = const [],
    this.isMore = true,
    this.courseInvitations = const [],
    this.coursePropose = const [],
    this.detailCourse = const {},
    this.courseLibrary = const [],
    this.courseSimilar = const [],
  });

  LearnSpaceState copyWith({
    List course = const [],
    List coursePropose = const [],
    List courseInvitations = const [],
    bool isMore = true,
    List courseLibrary = const [],
    dynamic detailCourse = const {},
    List courseSimilar = const [],
  }) {
    return LearnSpaceState(
      course: course,
      isMore: isMore,
      courseInvitations: courseInvitations,
      coursePropose: coursePropose,
      courseLibrary: courseLibrary,
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
      if (mounted) {
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
            courseLibrary: state.courseLibrary,
            courseInvitations: state.courseInvitations,
            coursePropose: state.coursePropose,
            courseSimilar: state.courseSimilar);
      }
    } else {
      final newGrows =
          response.where((item) => !state.course.contains(item)).toList();
      state = state.copyWith(
          course: params.containsKey('max_id')
              ? [...state.course, ...newGrows]
              : newGrows,
          isMore: false,
          detailCourse: state.detailCourse,
          courseLibrary: state.courseLibrary,
          courseInvitations: state.courseInvitations,
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
          courseInvitations: state.courseInvitations,
          coursePropose: state.coursePropose,
          courseLibrary: state.courseLibrary,
          courseSimilar: state.courseSimilar);
    }
  }

  getListCoursesLibraries() async {
    List response = await LearnSpaceApi().getListCoursesLibrariesApi();
    if (response.isNotEmpty) {
      state = state.copyWith(
          courseLibrary: response,
          course: state.course,
          detailCourse: state.detailCourse,
          courseInvitations: state.courseInvitations,
          coursePropose: state.coursePropose,
          isMore: state.isMore,
          courseSimilar: state.courseSimilar);
    }
  }

  getListCoursesInvitations(params) async {
    var response = await LearnSpaceApi().getListCoursesInvitationsApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        var newGrows = response['data']
            .where((item) => !state.courseInvitations
                .map((inv) => inv['course']['id'])
                .contains(item['course']['id']))
            .toList();
        state = state.copyWith(
            courseInvitations: [...state.courseInvitations, ...newGrows],
            courseLibrary: state.courseLibrary,
            course: state.course,
            detailCourse: state.detailCourse,
            coursePropose: state.coursePropose,
            isMore: newGrows.isEmpty ? false : state.isMore,
            courseSimilar: state.courseSimilar);
      }
    } else {
      var newGrows = response['data']
          .where((item) => !state.courseInvitations
              .map((inv) => inv['course']['id'])
              .contains(item['course']['id']))
          .toList();
      state = state.copyWith(
          courseInvitations: [...state.courseInvitations, ...newGrows],
          courseLibrary: state.courseLibrary,
          course: state.course,
          detailCourse: state.detailCourse,
          coursePropose: state.coursePropose,
          isMore: false,
          courseSimilar: state.courseSimilar);
    }
  }

  getListCoursesPropose(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          course: state.course,
          detailCourse: state.detailCourse,
          courseInvitations: state.courseInvitations,
          courseLibrary: state.courseLibrary,
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
          courseInvitations: state.courseInvitations,
          detailCourse: state.detailCourse,
          courseLibrary: state.courseLibrary,
          isMore: state.isMore,
          coursePropose: state.coursePropose,
          courseSimilar: response);
    }
  }

  updateStatusCourse(params, id) async {
    params == true
        ? await LearnSpaceApi().coursesUpdateStatusApi(id)
        : await LearnSpaceApi().coursesDeleteStatusApi(id);
    final indexCourseUpdate =
        state.course.indexWhere((element) => element['id'] == id.toString());
    final courseUpdate = {
      ...state.course[indexCourseUpdate],
      'course_relationships': {
        ...state.course[indexCourseUpdate]['course_relationships'],
        'follow_course': params
      }
    };
    state = state.copyWith(
      course: [...state.course]..[indexCourseUpdate] = courseUpdate,
      detailCourse: state.detailCourse,
      courseInvitations: state.courseInvitations,
      isMore: state.isMore,
      courseLibrary: state.courseLibrary,
      coursePropose: state.coursePropose,
      courseSimilar: state.courseSimilar,
    );
  }

  updatePaymentCourse(id) async {
    try {
      await LearnSpaceApi().coursesPaymentApi(id);
      dynamic response = await LearnSpaceApi().getDetailCoursesApi(id);
      state = state.copyWith(
        course: state.course,
        courseInvitations: state.courseInvitations,
        detailCourse: response,
        courseLibrary: state.courseLibrary,
        isMore: state.isMore,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
      );
      return true;
    } on DioError {
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
