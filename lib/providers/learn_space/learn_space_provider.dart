import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/learn_space_api.dart';

@immutable
class LearnSpaceState {
  final List course;
  final List coursePosts;
  final List courseInvitations;
  final List coursePropose;
  final List courseSimilar;
  final List courseLessonChapter;
  final List courseChapter;
  final bool isMore;
  final List courseLibrary;
  final dynamic detailCourse;
  final List courseFAQ;
  final List coursePurchased;
  final List courseReview;

  const LearnSpaceState({
    this.course = const [],
    this.isMore = true,
    this.courseInvitations = const [],
    this.courseLessonChapter = const [],
    this.detailCourse = const {},
    this.courseLibrary = const [],
    this.courseChapter = const [],
    this.coursePosts = const [],
    this.courseSimilar = const [],
    this.coursePropose = const [],
    this.courseFAQ = const [],
    this.coursePurchased = const [],
    this.courseReview = const [],
  });

  LearnSpaceState copyWith({
    List course = const [],
    List courseLessonChapter = const [],
    List courseInvitations = const [],
    bool isMore = true,
    List courseLibrary = const [],
    dynamic detailCourse = const {},
    List courseChapter = const [],
    List coursePosts = const [],
    List coursePropose = const [],
    List courseSimilar = const [],
    List courseFAQ = const [],
    List coursePurchased = const [],
    List courseReview = const [],
  }) {
    return LearnSpaceState(
      course: course,
      isMore: isMore,
      courseInvitations: courseInvitations,
      courseLessonChapter: courseLessonChapter,
      courseLibrary: courseLibrary,
      detailCourse: detailCourse,
      courseChapter: courseChapter,
      coursePosts: coursePosts,
      coursePropose: coursePropose,
      courseSimilar: courseSimilar,
      courseFAQ: courseFAQ,
      coursePurchased: coursePurchased,
      courseReview: courseReview,
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
          courseLessonChapter: state.courseLessonChapter,
          courseChapter: state.courseChapter,
          coursePosts: state.coursePosts,
          coursePropose: state.coursePropose,
          courseSimilar: state.courseSimilar,
          courseFAQ: state.courseFAQ,
          coursePurchased: state.coursePurchased,
          courseReview: state.courseReview,
        );
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
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
    }
  }

  getListCoursesPosts(params, id) async {
    List response = await LearnSpaceApi().getListCoursesPostsApi(params, id);
    if (response.isNotEmpty) {
      if (mounted) {
        final newGrows = response
            .where((item) => !state.coursePosts.contains(item))
            .toList();
        state = state.copyWith(
          coursePosts: params.containsKey('max_id')
              ? [...state.coursePosts, ...newGrows]
              : newGrows,
          isMore: params['limit'] != null
              ? response.length < params['limit'] || response.isEmpty
                  ? false
                  : true
              : false,
          course: state.course,
          detailCourse: state.detailCourse,
          courseLibrary: state.courseLibrary,
          courseInvitations: state.courseInvitations,
          courseLessonChapter: state.courseLessonChapter,
          courseChapter: state.courseChapter,
          courseFAQ: state.courseFAQ,
          coursePurchased: state.coursePurchased,
          courseReview: state.courseReview,
        );
      }
    } else {
      final newGrows =
          response.where((item) => !state.coursePosts.contains(item)).toList();
      state = state.copyWith(
        coursePosts: params.containsKey('max_id')
            ? [...state.coursePosts, ...newGrows]
            : newGrows,
        course: state.course,
        isMore: false,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        courseInvitations: state.courseInvitations,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
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
        courseLessonChapter: state.courseLessonChapter,
        courseLibrary: state.courseLibrary,
        courseChapter: state.courseChapter,
        coursePosts: state.coursePosts,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
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
        courseLessonChapter: state.courseLessonChapter,
        isMore: state.isMore,
        courseChapter: state.courseChapter,
        coursePosts: state.coursePosts,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
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
          courseLessonChapter: state.courseLessonChapter,
          isMore: newGrows.isEmpty ? false : state.isMore,
          courseChapter: state.courseChapter,
          coursePosts: state.coursePosts,
          coursePropose: state.coursePropose,
          courseSimilar: state.courseSimilar,
          courseFAQ: state.courseFAQ,
          coursePurchased: state.coursePurchased,
          courseReview: state.courseReview,
        );
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
        courseLessonChapter: state.courseLessonChapter,
        isMore: false,
        courseChapter: state.courseChapter,
        coursePosts: state.coursePosts,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
    }
  }

  getListCoursesLessonChapter(params) async {
    List response =
        await LearnSpaceApi().getListCoursesLessonChapterApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        course: state.course,
        detailCourse: state.detailCourse,
        courseInvitations: state.courseInvitations,
        courseLibrary: state.courseLibrary,
        courseLessonChapter: response,
        isMore: state.isMore,
        courseChapter: state.courseChapter,
        coursePosts: state.coursePosts,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
    } else {
      state = state.copyWith(
        course: state.course,
        detailCourse: state.detailCourse,
        courseInvitations: state.courseInvitations,
        courseLibrary: state.courseLibrary,
        courseLessonChapter: response,
        isMore: state.isMore,
        courseChapter: state.courseChapter,
        coursePosts: state.coursePosts,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
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
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
    }
  }

  getListCoursesChapter(params, id) async {
    List response = await LearnSpaceApi().getListCoursesChapterApi(params, id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        course: state.course,
        courseInvitations: state.courseInvitations,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        isMore: state.isMore,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: response,
        coursePosts: state.coursePosts,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
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
        courseSimilar: response,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
    }
  }

  getListCoursesFAQ(id) async {
    List response = await LearnSpaceApi().getListCoursesFAQApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        course: state.course,
        courseInvitations: state.courseInvitations,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        isMore: state.isMore,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: response,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
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
      courseLessonChapter: state.courseLessonChapter,
      courseChapter: state.courseChapter,
      coursePosts: state.coursePosts,
      coursePropose: state.coursePropose,
      courseSimilar: state.courseSimilar,
      courseFAQ: state.courseFAQ,
      coursePurchased: state.coursePurchased,
      courseReview: state.courseReview,
    );
  }

  getListCoursePurchased(params) async {
    var response = await LearnSpaceApi().getListCoursePurchasedApi(params);
    if (response != null) {
      state = state.copyWith(
        course: state.course,
        courseInvitations: state.courseInvitations,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        isMore: state.isMore,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        courseFAQ: state.courseFAQ,
        coursePurchased: response['data'],
        courseReview: state.courseReview,
      );
    }
  }

  getListCourseReview(params) async {
    var response = await LearnSpaceApi().getListCourseRatingApi(params);
    if (response != null) {
      state = state.copyWith(
        course: state.course,
        courseInvitations: state.courseInvitations,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        isMore: state.isMore,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: response,
      );
    }
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
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        coursePosts: state.coursePosts,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
      );
      return true;
    } on DioError {
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
