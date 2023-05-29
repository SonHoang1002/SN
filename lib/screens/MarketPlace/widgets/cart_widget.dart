import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:badges/badges.dart' as BadgeWidget;
import 'package:market_place/providers/market_place_providers/cart_product_provider.dart';
import 'package:market_place/theme/colors.dart';

import '../screen/cart_market_page.dart';

class CartWidget extends ConsumerStatefulWidget {
  Color? iconColor;
  CartWidget({super.key, this.iconColor});

  @override
  ConsumerState<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends ConsumerState<CartWidget> {
  @override
  Widget build(BuildContext context) {
    Color colorWord = primaryColor;

    return GestureDetector(
      onTap: () {
        pushToNextScreen(context, const CartMarketPage());
      },
      child: BadgeWidget.Badge(
        badgeContent: Text(
          "${ref.read(cartProductsProvider.notifier).getCartCounter(ref.watch(cartProductsProvider).listCart)}",
          style: const TextStyle(fontSize: 10),
        ),
        badgeColor: red,
        shape: BadgeWidget.BadgeShape.circle,
        showBadge: true,
        child: Icon(
          FontAwesomeIcons.cartArrowDown,
          size: 18,
          color: widget.iconColor ?? colorWord,
        ),
      ),
    );
  }
}
