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
      var theme = await SecureStorage().getKeyStorage('theme');
      var newList = await SecureStorage().getKeyStorage('dataLogin');
      List listAccount = [];

      if (newList != null && newList != 'noData') {
        listAccount = jsonDecode(newList) ?? [];
      }

      var newTheme =
          listAccount.map((e) => e['id']).toList().contains(response['id'])
              ? (listAccount
                      .firstWhere((e) => e['id'] == response['id'])!['theme'] ??
                  response['theme'])
              : response['theme'];

      var newAccount = {
        "id": response['id'],
        "name": response['display_name'],
        "show_url": response['avatar_media']['show_url'] ??
            response['avatar_media']['preview_url'],
        "token": token,
        "username": response['username'],
        "theme": newTheme
      };

      await SecureStorage().saveKeyStorage(
          jsonEncode(checkObjectUniqueInList([
            newAccount,
            ...listAccount,
          ], 'id')),
          'dataLogin');
      await SecureStorage().saveKeyStorage(response['id'], 'userId');
      if (theme == 'noData') {
        await SecureStorage().saveKeyStorage(
            listAccount.map((e) => e['id']).toList().contains(response['id'])
                ? newTheme
                : response['theme'],
            'theme');
      }

      state = [response];
    }
  }

  updateMedata(data) async {
    if (data != null) {
      state = [data];
    }
  }
}
