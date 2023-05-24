import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';

@immutable
class UserMediaState {
  final List photoUser;
  final bool isMorePhotoUser;
  final List albumUser;
  final bool isMoreAlbumUser;
  final List videoUser;
  final bool isMoreVideoUser;
  final List momentUser;
  final bool isMoreMomentUser;

  const UserMediaState({
    this.photoUser = const [],
    this.isMorePhotoUser = true,
    this.albumUser = const [],
    this.isMoreAlbumUser = true,
    this.videoUser = const [],
    this.isMoreVideoUser = true,
    this.momentUser = const [],
    this.isMoreMomentUser = true,
  });

  UserMediaState copyWith({
    List photoUser = const [],
    bool isMorePhotoUser = true,
    List albumUser = const [],
    bool isMoreAlbumUser = true,
    List videoUser = const [],
    bool isMoreVideoUser = true,
    List momentUser = const [],
    bool isMoreMomentUser = true,
  }) {
    return UserMediaState(
      photoUser: photoUser,
      isMorePhotoUser: isMorePhotoUser,
      albumUser: albumUser,
      isMoreAlbumUser: isMoreAlbumUser,
      videoUser: videoUser,
      isMoreVideoUser: isMoreVideoUser,
      momentUser: momentUser,
      isMoreMomentUser: isMoreMomentUser,
    );
  }
}

final userMediaControllerProvider =
    StateNotifierProvider.autoDispose<UserMediaController, UserMediaState>(
        (ref) {
  return UserMediaController();
});

class UserMediaController extends StateNotifier<UserMediaState> {
  UserMediaController() : super(const UserMediaState());

  getUserPhoto(id, params) async {
    List response = await UserPageApi().getUserMedia(id, params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        photoUser: response,
        isMorePhotoUser: state.isMorePhotoUser,
        albumUser: state.albumUser,
        isMoreAlbumUser: state.isMoreAlbumUser,
        videoUser: state.videoUser,
        isMoreVideoUser: state.isMoreVideoUser,
        momentUser: state.momentUser,
        isMoreMomentUser: state.isMoreMomentUser,
      );
    }
  }

  getUserAlbum(id, params) async {
    List response = await UserPageApi().getUserAlbum(id, params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        photoUser: state.photoUser,
        isMorePhotoUser: state.isMorePhotoUser,
        albumUser: response,
        isMoreAlbumUser: state.isMoreAlbumUser,
        videoUser: state.videoUser,
        isMoreVideoUser: state.isMoreVideoUser,
        momentUser: state.momentUser,
        isMoreMomentUser: state.isMoreMomentUser,
      );
    }
  }

  getUserVideo(id, params) async {
    List response = await UserPageApi().getUserMedia(id, params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        photoUser: state.photoUser,
        isMorePhotoUser: state.isMorePhotoUser,
        albumUser: state.albumUser,
        isMoreAlbumUser: state.isMoreAlbumUser,
        videoUser: response,
        isMoreVideoUser: state.isMoreVideoUser,
        momentUser: state.momentUser,
        isMoreMomentUser: state.isMoreMomentUser,
      );
    }
  }

  getUserMoment(id, params) async {
    List response = await UserPageApi().getUserMedia(id, params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        photoUser: state.photoUser,
        isMorePhotoUser: state.isMorePhotoUser,
        albumUser: state.albumUser,
        isMoreAlbumUser: state.isMoreAlbumUser,
        videoUser: state.videoUser,
        isMoreVideoUser: state.isMoreVideoUser,
        momentUser: response,
        isMoreMomentUser: state.isMoreMomentUser,
      );
    }
  }
}
