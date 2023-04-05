import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/market_place_apis/discover_product_api.dart';

class DiscoverProductsState {
  List<dynamic> listDiscover;
  DiscoverProductsState({this.listDiscover = const []});
  DiscoverProductsState copyWith(List<dynamic> list) {
    return DiscoverProductsState(listDiscover: list);
  }
}

final discoverProductsProvider =
    StateNotifierProvider<DiscoverProductsController, DiscoverProductsState>(
        (ref) => DiscoverProductsController());

class DiscoverProductsController extends StateNotifier<DiscoverProductsState> {
  DiscoverProductsController() : super(DiscoverProductsState());

  getDiscoverProducts({int? count}) async {
    List<dynamic> response =
        await DiscoverProductsApi().getListDiscoverProductsApi() ?? [];
    List<dynamic> data =
        count != null ? response.take(count).toList() : response;
    state = state.copyWith(data);
  }
}
