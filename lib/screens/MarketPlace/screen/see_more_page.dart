import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/main_market_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

import '../widgets/product_item_widget.dart';

class SeeMoreMarketPage extends ConsumerStatefulWidget {
  const SeeMoreMarketPage({super.key});

  @override
  ConsumerState<SeeMoreMarketPage> createState() => _SeeMoreMarketPageState();
}

class _SeeMoreMarketPageState extends ConsumerState<SeeMoreMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _seeMoreProductList;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final datas = ref.watch(productsProvider).list;
      setState(() {
        _seeMoreProductList = datas;
      });
    });
    _scrollController.addListener(() async {
      if (double.parse((_scrollController.offset).toStringAsFixed(0)) ==
          double.parse((_scrollController.position.maxScrollExtent)
              .toStringAsFixed(0))) {
        dynamic params = {
          "offset": ref.watch(productsProvider).list.length,
          ...paramConfigProductSearch,
        };
        ref.read(productsProvider.notifier).getProductsSearch(params);
        setState(() {
          _isLoading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _seeMoreProductList = ref.watch(productsProvider).list;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            AppBarTitle(title: "Danh sách sản phẩm"),
            Icon(
              FontAwesomeIcons.bell,
              size: 18,
              color: Colors.black,
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: buildSuggestListComponent(
            context: context,
            title: const SizedBox(),
            controller: _scrollController,
            contentList: _seeMoreProductList!,
            isLoading: _isLoading,
            isLoadingMore: ref.watch(productsProvider).isMore),
      ),
    );
  }
}
