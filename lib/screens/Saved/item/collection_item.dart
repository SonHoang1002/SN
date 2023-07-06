import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/saved/saved_menu_item_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:provider/provider.dart' as pv;

import '../see_collection_bookmark.dart';

class CollectionItem extends ConsumerStatefulWidget {
  final dynamic item;
  const CollectionItem({super.key, this.item});

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
    double width = MediaQuery.of(context).size.width;
    final theme = pv.Provider.of<ThemeManager>(context);
    return CardComponents(
      imageCard: SizedBox(
        height: height > width ? height / 8.5 : height / 1.6,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: widget.item['mediaWidget'],
        ),
      ),
      onTap: () async {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SeeCollectionBookmark(
              collectionId: collections[index]['id'],
              collectionName: collections[index]['name'],
            ),
          ),
        );
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
