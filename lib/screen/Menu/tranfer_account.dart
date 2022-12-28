import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/tranfer_account.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class TranferAccount extends StatelessWidget {
  const TranferAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 400,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Column(
              children: [
                const AppbarTitle(title: "Chuyển tài khoản"),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 0.2,
                  width: size.width,
                  color: greyColor,
                )
              ],
            )),
        body: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            children: List.generate(
                tranferAccounts.length,
                (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              AvatarSocial(
                                  width: 36,
                                  height: 36,
                                  path:
                                      // tranferAccounts[index]['show_url'] ??
                                      linkAvatarDefault),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                tranferAccounts[index]['name'],
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          const Radio(
                              value: false, groupValue: true, onChanged: null)
                        ],
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
