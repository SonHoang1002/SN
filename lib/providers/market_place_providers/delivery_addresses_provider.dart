import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/delivery_address_apis.dart';

class DeliveryAddressState {
  List<dynamic> addressList;
  DeliveryAddressState({this.addressList = const []});
  DeliveryAddressState copyWith(List<dynamic> list) {
    return DeliveryAddressState(addressList: list);
  }
}

final deliveryAddressProvider =
    StateNotifierProvider<DeliveryAddressController, DeliveryAddressState>(
        (ref) => DeliveryAddressController());

class DeliveryAddressController extends StateNotifier<DeliveryAddressState> {
  DeliveryAddressController() : super(DeliveryAddressState());

  createDeliveryAddress(dynamic data) async {
    final response = await DeliveryAddressApis().postDeliveryAddressApi(data);
    print("delivaryAddress createDeliveryAddress: $response");
    state = state.copyWith(response);
  }

  getDeliveryAddressList() async {
    final response = await DeliveryAddressApis().getDeliveryAddressApi();
    print("delivaryAddress getDeliveryAddressList: $response");
    state = state.copyWith(response);
  }

  updateDeliveryAddress(dynamic data) async {
    final response = await DeliveryAddressApis().updateDeliveryAddressApi(data);
    print("delivaryAddress updateDeliveryAddress: $response");
    state = state.copyWith(response);
  }

  deleteDeliveryAddress(dynamic data) async {
    final response = await DeliveryAddressApis().deleteDeliveryAddressApi(data);
    print("delivaryAddress deleteDeliveryAddress: $response");
    state = state.copyWith(response);
  }
}
