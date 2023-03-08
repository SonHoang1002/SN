import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/cart_product_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:badges/badges.dart' as BadgeWidget;
import '../../../helper/push_to_new_screen.dart';

class CartWidget extends ConsumerWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? colorTheme = ThemeMode.light == true
        ? Theme.of(context).cardColor
        : const Color(0xfff1f2f5);
    return GestureDetector(
      onTap: () {
        pushToNextScreen(context, const CartMarketPage());
      },
      child: BadgeWidget.Badge(
        badgeContent:
            Text("${ref.watch(cartProductsProvider).listCart.length ?? "0"}"),
        badgeColor: Colors.red,
        shape: BadgeWidget.BadgeShape.circle,
        showBadge: true,
        child: Icon(
          FontAwesomeIcons.cartArrowDown,
          size: 16,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
