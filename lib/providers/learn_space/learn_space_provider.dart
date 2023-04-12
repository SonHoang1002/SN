import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/learn_space_api.dart';

@immutable
class LearnSpaceState {
  final List course;
  final List courseFee;
  final List courseNoFee;

  const LearnSpaceState({
    this.course = const [],
    this.courseFee = const [],
    this.courseNoFee = const [],
  });

  LearnSpaceState copyWith({
    List course = const [],
    List courseFee = const [],
    List courseNoFee = const [],
  }) {
    return LearnSpaceState(
      course: course,
      courseFee: courseFee,
      courseNoFee: courseNoFee,
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
      state = state.copyWith(
        course: response,
        courseFee: state.courseFee,
        courseNoFee: state.courseNoFee,
      );
    }
  }

  getListCoursesFee(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        course: state.course,
        courseFee: response,
        courseNoFee: state.courseNoFee,
      );
    }
  }

  getListCoursesNoFee(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        course: state.course,
        courseNoFee: response,
        courseFee: state.courseNoFee,
      );
    }
  }
}
