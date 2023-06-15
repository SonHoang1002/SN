import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widgets/Bookmark/collection_item.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class SeeAllCollection extends ConsumerStatefulWidget {
  dynamic collections;

  SeeAllCollection({super.key, this.collections});

  @override
  SeeAllCollectionState createState() => SeeAllCollectionState();
}

class SeeAllCollectionState extends ConsumerState<SeeAllCollection> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          children: const [
            BackIconAppbar(),
            SizedBox(width: 10.0),
            AppBarTitle(title: "Bộ sưu tập của bạn"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Text(
                    'Bộ sưu tập của bạn',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
              height: height,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.hardEdge,
                itemCount: widget.collections.length >= 4
                    ? 4
                    : widget.collections.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  crossAxisCount: 2,
                  childAspectRatio: 1.12,
                ),
                itemBuilder: (context, index) {
                  var item = widget.collections[index];
                  return CollectionItem(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
