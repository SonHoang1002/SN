import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/me_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

final meControllerProvider =
    StateNotifierProvider<MeController, List<dynamic>>((ref) => MeController());

class MeController extends StateNotifier<List> {
  MeController() : super([]);

  getMeData() async {
    var response = await MeApi().fetchDataMeApi();

    if (response != null) {
      var token = await SecureStorage().getKeyStorage("token");
      var newList = await SecureStorage().getKeyStorage('dataLogin');
      List listAccount = [];

      if (newList != null && newList != 'noData') {
        listAccount = jsonDecode(newList) ?? [];
      }

      var newAccount = {
        "id": response['id'],
        "name": response['display_name'],
        "show_url": response['avatar_media']['show_url'] ??
            response['avatar_media']['preview_url'],
        "token": token,
        "username": response['username'],
        "theme": response['theme']
      };

      await SecureStorage().saveKeyStorage(
          jsonEncode(checkObjectUniqueInList([
            newAccount,
            ...listAccount,
          ], 'id')),
          'dataLogin');
      await SecureStorage().saveKeyStorage(response['id'], 'userId');
      await SecureStorage().saveKeyStorage(response['theme'], 'theme');

      state = [response];
    }
  }

  updateMedata(data) async {
    if (data != null) {
      state = [data];
    }
  }
}
