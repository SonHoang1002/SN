// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screens/Feed/create_post_button.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/theme_manager.dart';

class NewPostArea extends StatelessWidget {
  const NewPostArea({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/chia_se_ngay_black.png",
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Tạo bài viết mới",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 2,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: CreatePostButton(
              preType: postPageUser,
            ),
          ),
          Divider(
            height: 1,
            thickness: 2,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
