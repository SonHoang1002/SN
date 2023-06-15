import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:provider/provider.dart' as pv;

class CollectionItem extends StatelessWidget {
  dynamic item;

  CollectionItem({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);
    return CardComponents(
      imageCard: SizedBox(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: Image.network(
            item['imageUrl'],
            fit: BoxFit.cover,
            width: double.infinity,
            height: height / 8.5,
          ),
        ),
      ),
      onTap: () {},
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
                item['name'],
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
