import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:social_network_app_mobile/model/post_model.dart';
import 'package:social_network_app_mobile/model/post_users.dart';
import 'package:social_network_app_mobile/services/isar_service.dart';

class IsarPostService {
  Future<List> getPostsWithNumber(int number, dynamic lastPost) async {
    List postsOnIsar = await getAllPostsFromIsar();
    int indexOnIsar = postsOnIsar.indexWhere((e) => e['id'] == lastPost['id']);
    if (indexOnIsar >= 0) {
      // kiem tra xem trong isar co du so luong bai can khong
      if (indexOnIsar + number < (await getCountPostIsar())) {
        return [...postsOnIsar.sublist(indexOnIsar + 1, indexOnIsar + number)];
      } else {
        return [...postsOnIsar];
      }
    }
    return [];
  }

  Future<int> getCountPostIsar() async {
    final instance = await IsarService.instance;
    final count = await instance.postModels.count();
    return count;
  }

  Future<List> getAllPostsFromIsar() async {
    final instance = await IsarService.instance;
    final postsModelIsar = await instance.postModels.where().findAll();
    return postsModelIsar.map((e) => jsonDecode(e.objectPost!)).toList();
  }

  addPostIsar(List listPost) async {
    final instance = await IsarService.instance;
    await instance.writeTxn(() async {
      for (var newPost in listPost) {
        await instance.postModels.put(PostModel()
          ..objectPost = jsonEncode(newPost)
          ..postId = (newPost['id']));
      }
    });
  }

  resetPostIsar() async {
    final instance = await IsarService.instance;
    if (instance.isOpen == true) {
      print("resetPostIsar resetPostIsar resetPostIsar");
      instance.writeTxn(() async {
        await instance.postModels.where().deleteAll();
      });
    }
  }

  //
  getEarlyPost() async {
    final instance = await IsarService.instance;
    if (instance.isOpen == true) {
      final allPost = await instance.postModels.where().findAll();
      if (allPost.length > 100) {
        final early100Post = allPost.reversed.take(100).toList();
        await resetPostIsar();
        await instance.writeTxn(() async {
          for (var post in early100Post) {
            await instance.postModels.put(post);
          }
        });
      }
    } else {
      print("cba cba cba cba");
    }
  }
}

class IsarPostUsers {
  Future getCurrentUserByToken(String token) async {
    print("-----");
    final instance = await IsarService.instance;
    final listUser =
        await instance.postDataUsers.where(distinct: true).findAll();
    print("listUser ${listUser[0]}");
    // if (instance.isOpen == true) {
    //   // final listUser = await instance.postDataUsers.where().findAll();
    //   // print("listUser ${jsonDecode(listUser[0].listUser!)}");
    //   print("listUser listUser listUser listUser");
    // } else {
    //   print("0909090990");
    // }
  }

  resetPostUsers() async {
    final instance = await IsarService.instance;
    if (instance.isOpen == true) {
      await instance.writeTxn(() async {
        await instance.postDataUsers.where().deleteAll();
      });
    }
  }

  initPostUsers(dynamic userData) async {
    final instance = await IsarService.instance;
    await instance.writeTxn(() async {
      var primaryList = [
        {
          "userData": userData,
          "objectPosts": [
            {"1": "shdfsd"},
            {"2": "jhsgdjfsgdjfh"}
          ]
        },
      ];
      print("primaryList ${jsonEncode(primaryList)}");
      await instance.postDataUsers
          .put(PostDataUsers()..listUser = jsonEncode(primaryList));
    });
  }
}
