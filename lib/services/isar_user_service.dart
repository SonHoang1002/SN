import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:social_network_app_mobile/model/user/user_model.dart';

import 'isar_service.dart';

class IsarUserService {
  Future<void> addPostIsar(
    userData,
    userAbout,
    lifeEvent,
    pinPost,
    postUser,
    friend,
    featureContent,
    String userType,
  ) async {
    final instance = await IsarService.instance;
    final user = await findUser(userAbout['id']);
    if (user == null) {
      instance.writeTxn(() async {
        await instance.userModels.put(
          UserModel()
            ..userType = userType
            ..userData = jsonEncode(userData)
            ..userAbout = jsonEncode(userAbout)
            ..lifeEvent = jsonEncode(lifeEvent)
            ..pinPost = jsonEncode(pinPost)
            ..postUser = jsonEncode(postUser)
            ..friend = jsonEncode(friend)
            ..featureContent = jsonEncode(featureContent)
            ..userId = (userAbout['id']),
        );
      });
    }
  }

  Future<UserModel?> findUser(userId) async {
    final instance = await IsarService.instance;
    final user =
        await instance.userModels.filter().userIdEqualTo(userId).findFirst();
    return user;
  }

  Future<void> resetPostIsar() async {
    final instance = await IsarService.instance;
    if (instance.isOpen == true) {
      instance.writeTxn(() async {
        await instance.userModels.where().deleteAll();
      });
    }
  }
}
