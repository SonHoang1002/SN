import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

import '../../../../widget/back_icon_appbar.dart';

class NotificationMarketPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(title: "Thông báo"),
              SizedBox()
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: [
                    Container(height: 300,),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: buildTextContent("Không có thông báo nào ", true,
                          fontSize: 19, isCenterLeft: false, function: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: transparent,
                          builder: (context) => MyBottomSheet(),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
            //
          ],
        ));
  }
}

class MyBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6, // initial size of the sheet
        minChildSize: 0.2, // minimum size of the sheet
        maxChildSize: 1.0, // maximum size of the sheet
        builder: (context, scrollController) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              controller: scrollController,
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          );
        },
      ),
    );
  }
}
