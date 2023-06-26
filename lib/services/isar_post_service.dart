import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/model/post_model.dart'; 
import 'package:social_network_app_mobile/services/isar_service.dart';

class IsarPostService {
  Future<int> getPostIsar() async {
    final _instance = await IsarService.instance;
    final count = await _instance.postModels.count();
    return count;
  }

  addPostIsar(List listPost) async {
      final _instance = await IsarService.instance;
    await _instance.writeTxn(() async {
      for (var newPost in listPost) {
        await _instance.postModels.put(PostModel()
          ..objectPost = jsonEncode(newPost)
          ..postId = (newPost['id']));
      }
    });
  }

  resetPostIsar() async {
    final _instance = await IsarService.instance;
    if (_instance.isOpen == true) {
      _instance.writeTxn(() async {
        await _instance.postModels.where().deleteAll();
      });
    }
  }
}
