import 'package:social_network_app_mobile/apis/api_root.dart';

class LearnSpaceApi {
  Future getListCoursesApi(params) async {
    return await Api().getRequestBase('/api/v1/courses', params);
  }

  Future getListCoursesChapterApi(params, id) async {
    return await Api()
        .getRequestBase('/api/v1/courses/$id/course_chapters', params);
  }

  Future getListCoursesFAQApi(id) async {
    return await Api().getRequestBase('/api/v1/courses/$id/course_faqs', null);
  }

  Future getListCoursesLessonChapterApi(params) async {
    return await Api().getRequestBase('/api/v1/course_lessons', params);
  }

  Future getListCoursesPostsApi(params, id) async {
    return await Api().getRequestBase('/api/v1/timelines/course/$id', params);
  }

  Future getListCoursesLibrariesApi() async {
    return await Api().getRequestBase('/api/v1/course_content_library', null);
  }

  Future getListCoursesInvitationsApi(params) async {
    return await Api().getRequestBase('/api/v1/course_invitations', params);
  }

  Future getDetailCoursesApi(id) async {
    return await Api().getRequestBase('/api/v1/courses/$id', null);
  }

  Future coursesUpdateStatusApi(id) async {
    try {
      return await Api()
          .postRequestBase('/api/v1/courses/$id/course_followers', null);
    } catch (e) {
      return e;
    }
  }

  Future coursesDeleteStatusApi(id) async {
    return await Api()
        .deleteRequestBase('/api/v1/courses/$id/course_followers', null);
  }

  Future coursesPaymentApi(id) async {
    try {
      return await Api().postRequestBase('/api/v1/courses/$id/payment_course',
          {"detail_type": "payment_course"});
    } catch (e) {
      rethrow;
    }
  }
}
