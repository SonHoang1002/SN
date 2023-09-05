import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/apis/moment_api.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:video_compress/video_compress.dart';

@immutable
class MomentState {
  final List momentSuggest;
  final List momentFollow;
  final dynamic momentUpload;

  const MomentState(
      {this.momentSuggest = const [],
      this.momentFollow = const [],
      this.momentUpload = const {}});

  MomentState copyWith(
      {List momentSuggest = const [],
      List momentFollow = const [],
      dynamic momentUpload = const {}}) {
    return MomentState(
        momentSuggest: momentSuggest,
        momentFollow: momentFollow,
        momentUpload: momentUpload);
  }
}

final momentControllerProvider =
    StateNotifierProvider.autoDispose<MomentController, MomentState>((ref) {
  ref.read(meControllerProvider);
  return MomentController();
});

class MomentController extends StateNotifier<MomentState> {
  MomentController() : super(const MomentState());

  reset() {
    state = const MomentState();
  }

  getListMomentFollow(params) async {
    List response = await MomentApi().getListMomentFollow(params) ?? [];
    List listResult = checkObjectUniqueInList(state.momentFollow + response, "id");
    state = state.copyWith(
        momentFollow:
            listResult,
        momentSuggest: state.momentSuggest);
  }

  updateReaction(reaction, id) async {
    if (mounted) {
      var tempDataFollow = state.momentFollow.map((e) {
        if (e['id'] == id) {
          // nếu  viewer_reaction đã là love thì xóa viewer_reaction và trừ đi count 1
          // nếu  viewer_reaction không là love thì viewer_reaction bằng viewer_reaction và count +1
          if (e['viewer_reaction'] != "love") {
            return {
              ...e,
              'viewer_reaction': reaction,
              'favourites_count': e['favourites_count'] + 1
            };
          } else {
            if (reaction == "love") {
              return e;
            } else {
              dynamic newFollow = e;
              newFollow['viewer_reaction'] = null;
              newFollow['favourites_count'] = e['favourites_count'] - 1;
              return newFollow;
            }
          }
        } else {
          return e;
        }
      }).toList();
      var tempDataSuggest = state.momentSuggest.map((e) {
        if (e['id'] == id) {
          // nếu  viewer_reaction đã là love thì xóa viewer_reaction và trừ đi count 1
          // nếu  viewer_reaction không là love thì viewer_reaction bằng viewer_reaction và count +1
          if (e['viewer_reaction'] != "love") {
            return {
              ...e,
              'viewer_reaction': reaction,
              'favourites_count': e['favourites_count'] + 1
            };
          } else {
            if (reaction == "love") {
              return e;
            } else {
              dynamic newFollow = e;
              newFollow['viewer_reaction'] = null;
              newFollow['favourites_count'] = e['favourites_count'] - 1;
              return newFollow;
            }
          }
        } else {
          return e;
        }
      }).toList();
      state = state.copyWith(
          momentFollow: tempDataFollow, momentSuggest: tempDataSuggest);
      var response;
      if (reaction == 'love') {
        response = await MomentApi()
            .favoriteReactionMoment(id, {"custom_vote_type": reaction});
      } else if (reaction == null) {
        response = await MomentApi().unfavoriteReactionMoment(id);
      } else {}
    }
  }

  getListMomentSuggest(params) async {
    List response = await MomentApi().getListMomentSuggest(params) ?? [];
    if (mounted) {
      final newMoment = response
          .where((item) => !state.momentSuggest.contains(item))
          .toList();
      state = state.copyWith(
          momentFollow: state.momentFollow,
          momentSuggest: params.containsKey('max_id')
              ? checkObjectUniqueInList([...state.momentSuggest, ...newMoment], "id")
              : newMoment);
    }
  }

  updateMomentDetail(type, newMoment) {
    int index = -1;

    if (type == 'follow') {
      index = state.momentFollow
          .indexWhere((element) => element['id'] == newMoment['id']);
    } else if (type == 'suggest') {
      index = state.momentSuggest
          .indexWhere((element) => element['id'] == newMoment['id']);
    }

    if (mounted && index >= 0) {
      state = state.copyWith(
          momentFollow: type == 'follow'
              ? state.momentFollow.sublist(0, index) +
                  [newMoment] +
                  state.momentFollow.sublist(index + 1)
              : state.momentFollow,
          momentSuggest: type == 'forget'
              ? state.momentSuggest.sublist(0, index) +
                  [newMoment] +
                  state.momentSuggest.sublist(index + 1)
              : state.momentSuggest);
    }
  }

  // user: theo doi
  // group : gui loi moi tham gia
  // page : thich nhom
  followMoment(
    dynamic type,
    dynamic id,
  ) async {
    var response;
    if (type == momentUser) {
      // id là userId
      response =
          await Api().postRequestBase("/api/v1/accounts/$id/follow", null);
    } else if (type == momentPage) {
      // id là pageId
      response = await Api().postRequestBase("/api/v1/pages/$id/likes", null);
    } else if (type == momentGroup) {
      response =
          await Api().postRequestBase("/api/v1/groups/$id/accounts", null);
    }
  }

  updateMomentUpload(
      String videoPath, File imageCover, dynamic data, snackbar) async {
    try {
      Future<String> imageToBase64(String imagePath) async {
        final bytes = await File(imagePath).readAsBytes();
        final base64Str = base64Encode(bytes);
        return 'data:image/jpeg;base64,$base64Str';
      }

      handleUploadMedia(fileData, File imageCover) async {
        fileData = fileData.replaceAll('file://', '');
        MediaInfo? info;

        try {
          info = await VideoCompress.compressVideo(
            fileData,
            quality: VideoQuality.Res1280x720Quality,
            deleteOrigin: false, // Keeping the original video
            includeAudio: true, // Including audio
          );

          if (info != null) {
            FormData formData = FormData.fromMap({
              "description": '',
              "position": 1,
              "file": await MultipartFile.fromFile(
                info.path ?? '',
                filename: info.path!.split('/').last,
              ),
              "show_url": await imageToBase64(imageCover.path),
            });

            var response = await MediaApi().uploadMediaEmso(formData);
            // Remember to delete cache
            VideoCompress.deleteAllCache();

            return response;
          }
        } catch (e) {
          snackbar.showSnackBar(SnackBar(content: Text(e.toString())));
          // Remember to cancel compression and delete cache in case of an error
          VideoCompress.cancelCompression();
          VideoCompress.deleteAllCache();
          rethrow; // Re-throwing the exception to handle it outside this function
        }
      }

      var mediaUploadResult = await handleUploadMedia(videoPath, imageCover);
      if (mediaUploadResult == null) {
        snackbar.showSnackBar(const SnackBar(
            content: Text(
                'Có lỗi xảy ra trong quá trình đăng, vui lòng thử lại sau!')));
      }

      dynamic response = await PostApi().createStatus({
        ...data,
        "media_ids": [mediaUploadResult['id']],
      });
      if (response != null) {
        state = state.copyWith(
            momentFollow: state.momentFollow,
            momentSuggest: [response] + state.momentSuggest,
            momentUpload: response);
      }
    } catch (e) {
      snackbar.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  clearMomentUpload() {
    state = state.copyWith(
        momentFollow: state.momentFollow,
        momentSuggest: state.momentSuggest,
        momentUpload: {});
  }
}
