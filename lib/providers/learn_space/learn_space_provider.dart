import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/learn_space_api.dart';
import 'package:social_network_app_mobile/widgets/show_modal_message.dart';

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
  final List coursesChipMenu;
  final List coursesNoFee;
  final List coursesFee;
  final List coursesHost;
  final List coursesInterest;

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
    this.coursesChipMenu = const [],
    this.coursesNoFee = const [],
    this.coursesFee = const [],
    this.coursesHost = const [],
    this.coursesInterest = const [],
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
    List coursesChipMenu = const [],
    List coursesNoFee = const [],
    List coursesFee = const [],
    List coursesHost = const [],
    List coursesInterest = const [],
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
      coursesChipMenu: coursesChipMenu,
      coursesNoFee: coursesNoFee,
      coursesFee: coursesFee,
      coursesHost: coursesHost,
      coursesInterest: coursesInterest,
    );
  }
}

final learnSpaceStateControllerProvider =
    StateNotifierProvider<LearnSpaceController, LearnSpaceState>(
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  getListCoursesNoFee(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        final newGrows = response
            .where((item) => !state.coursesNoFee.contains(item))
            .toList();
        state = state.copyWith(
          course: state.course,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: params.containsKey('max_id')
              ? [...state.coursesNoFee, ...newGrows]
              : newGrows,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
        );
      }
    } else {
      final newGrows =
          response.where((item) => !state.coursesNoFee.contains(item)).toList();
      state = state.copyWith(
        course: state.course,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: params.containsKey('max_id')
            ? [...state.coursesNoFee, ...newGrows]
            : newGrows,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  getListCoursesHost(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        final newGrows = response
            .where((item) => !state.coursesHost.contains(item))
            .toList();
        state = state.copyWith(
          course: state.course,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: params.containsKey('max_id')
              ? [...state.coursesHost, ...newGrows]
              : newGrows,
          coursesInterest: state.coursesInterest,
        );
      }
    } else {
      final newGrows =
          response.where((item) => !state.coursesHost.contains(item)).toList();
      state = state.copyWith(
        course: state.course,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: params.containsKey('max_id')
            ? [...state.coursesHost, ...newGrows]
            : newGrows,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  getListCoursesInterest(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        final newGrows = response
            .where((item) => !state.coursesInterest.contains(item))
            .toList();
        state = state.copyWith(
          course: state.course,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: params.containsKey('max_id')
              ? [...state.coursesInterest, ...newGrows]
              : newGrows,
        );
      }
    } else {
      final newGrows = response
          .where((item) => !state.coursesInterest.contains(item))
          .toList();
      state = state.copyWith(
        course: state.course,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: params.containsKey('max_id')
            ? [...state.coursesInterest, ...newGrows]
            : newGrows,
      );
    }
  }

  getListCoursesFee(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        final newGrows =
            response.where((item) => !state.coursesFee.contains(item)).toList();
        state = state.copyWith(
          course: state.course,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: params.containsKey('max_id')
              ? [...state.coursesFee, ...newGrows]
              : newGrows,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
        );
      }
    } else {
      final newGrows =
          response.where((item) => !state.coursesFee.contains(item)).toList();
      state = state.copyWith(
        course: state.course,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: params.containsKey('max_id')
            ? [...state.coursesFee, ...newGrows]
            : newGrows,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  getListCoursesChipMenu(params) async {
    List response = await LearnSpaceApi().getListCoursesApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        final newGrows = response
            .where((item) => !state.coursesChipMenu.contains(item))
            .toList();
        state = state.copyWith(
          coursesChipMenu: params.containsKey('max_id')
              ? [...state.coursesChipMenu, ...newGrows]
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
          coursePosts: state.coursePosts,
          coursePropose: state.coursePropose,
          courseSimilar: state.courseSimilar,
          courseFAQ: state.courseFAQ,
          coursePurchased: state.coursePurchased,
          courseReview: state.courseReview,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
        );
      }
    } else {
      final newGrows = response
          .where((item) => !state.coursesChipMenu.contains(item))
          .toList();
      state = state.copyWith(
        course: state.course,
        coursesChipMenu: params.containsKey('max_id')
            ? [...state.coursesChipMenu, ...newGrows]
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
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  //
  createPostLearnSpace(type, newPost) {
    if (mounted) {
      state = state.copyWith(
        course: state.course,
        isMore: true,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        courseInvitations: state.courseInvitations,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        coursePosts: [newPost] + state.coursePosts,
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  changeProcessingPostLearnSpace(dynamic newData) {
    if (mounted) {
      state = state.copyWith(
        course: state.course,
        isMore: true,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        courseInvitations: state.courseInvitations,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        coursePosts: [
          ...state.coursePosts.sublist(0, 0),
          newData,
          ...state.coursePosts.sublist(1)
        ],
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  actionHiddenDeletePost(type, data) {
    int index = -1;
    index =
        state.coursePosts.indexWhere((element) => element['id'] == data['id']);
    if (index < 0) return;
    if (mounted) {
      state = state.copyWith(
        course: state.course,
        isMore: true,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        courseInvitations: state.courseInvitations,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        coursePosts: [
          ...state.coursePosts.sublist(0, index),
          ...state.coursePosts.sublist(index + 1)
        ],
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  actionUpdateDetailInPost(
    dynamic type,
    dynamic newData,
  ) async {
    int index = -1;
    index = state.coursePosts
        .indexWhere((element) => element['id'] == newData['id']);
    if (index < 0) return;

    if (mounted) {
      state = state.copyWith(
        course: state.course,
        isMore: true,
        detailCourse: state.detailCourse,
        courseLibrary: state.courseLibrary,
        courseInvitations: state.courseInvitations,
        courseLessonChapter: state.courseLessonChapter,
        courseChapter: state.courseChapter,
        coursePosts: [
          ...state.coursePosts.sublist(0, index),
          newData,
          ...state.coursePosts.sublist(index + 1)
        ],
        coursePropose: state.coursePropose,
        courseSimilar: state.courseSimilar,
        courseFAQ: state.courseFAQ,
        coursePurchased: state.coursePurchased,
        courseReview: state.courseReview,
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  updateStatusCourse(params, id, {String name = 'course'}) async {
    params == true
        ? await LearnSpaceApi().coursesUpdateStatusApi(id)
        : await LearnSpaceApi().coursesDeleteStatusApi(id);

    List courseList;
    switch (name) {
      case 'coursesNoFee':
        courseList = state.coursesNoFee;
        break;
      case 'coursesFee':
        courseList = state.coursesFee;
        break;
      case 'coursesLearned':
        courseList = state.coursesChipMenu;
        break;
      case 'coursesInterest':
        courseList = state.coursesInterest;
        break;
      default:
        courseList = state.course;
        break;
    }
    final indexCourseUpdate =
        courseList.indexWhere((element) => element['id'] == id.toString());
    final courseUpdate = {
      ...courseList[indexCourseUpdate],
      'course_relationships': {
        ...courseList[indexCourseUpdate]['course_relationships'],
        'follow_course': params
      }
    };
    switch (name) {
      case 'coursesNoFee':
        state = state.copyWith(
          course: state.course,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: [...state.coursesNoFee]..[indexCourseUpdate] =
              courseUpdate,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
        );
        break;
      case 'coursesFee':
        state = state.copyWith(
          course: state.course,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: [...state.coursesFee]..[indexCourseUpdate] = courseUpdate,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
        );
        break;
      case 'coursesLearned':
        state = state.copyWith(
          course: state.course,
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
          coursesChipMenu: [...state.coursesHost]..[indexCourseUpdate] =
              courseUpdate,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
        );
        break;
      case 'coursesInterest':
        state = state.copyWith(
          course: state.course,
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: [...state.coursesInterest]..[indexCourseUpdate] =
              courseUpdate,
        );
        break;
      default:
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
          coursesChipMenu: state.coursesChipMenu,
          coursesNoFee: state.coursesNoFee,
          coursesFee: state.coursesFee,
          coursesHost: state.coursesHost,
          coursesInterest: state.coursesInterest,
        );
        break;
    }
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    }
  }

  Future<void> updatePaymentCourse(id, BuildContext ctx) async {
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
        coursesChipMenu: state.coursesChipMenu,
        coursesNoFee: state.coursesNoFee,
        coursesFee: state.coursesFee,
        coursesHost: state.coursesHost,
        coursesInterest: state.coursesInterest,
      );
    } on DioError catch (e) {
      showSnackbar(
        ctx,
        e.response!.data['error'].toString(),
      );
      rethrow;
    }
  }
}
