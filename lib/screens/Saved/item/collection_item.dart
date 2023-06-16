import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/saved/saved_menu_item_provider.dart';
import 'package:social_network_app_mobile/screens/Saved/see_all_bookmark.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:provider/provider.dart' as pv;

class CollectionItem extends ConsumerStatefulWidget {
  dynamic item;
  void Function() func;
  CollectionItem({super.key, this.item, required this.func});

  @override
  CollectionItemState createState() => CollectionItemState();
}

class CollectionItemState extends ConsumerState<CollectionItem> {
  @override
  Widget build(BuildContext context) {
    final collections = ref.watch(savedControllerProvider).bmCollections;
    final index = collections.indexWhere(
      (element) => element['id'] == widget.item['id'],
    );

    double height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);
    return CardComponents(
      imageCard: SizedBox(
        height: height / 8.5,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: widget.item['imageWidget'],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SeeAllBookmark(
              type: 'collection_bookmark',
              collectionId: widget.item['id'],
              collectionName: collections[index]['name'],
            ),
          ),
        ).then((_) => widget.func());
      },
      textCard: Container(
        // color: Colors.red,
        padding: const EdgeInsets.only(
          right: 10.0,
          left: 10.0,
          top: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                collections[index]['name'],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                'Chỉ mình tôi',
                style: TextStyle(
                  fontSize: 12.5,
                  color: greyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
