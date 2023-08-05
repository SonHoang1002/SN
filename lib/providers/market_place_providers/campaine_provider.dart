import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/campaine_api.dart';

final campaineProvider =
    StateNotifierProvider<CampaineController, CampaineState>(
        (ref) => CampaineController());

class CampaineController extends StateNotifier<CampaineState> {
  CampaineController() : super(CampaineState());

  getCampaine() async {
    final response = await CampaineProductApi().getCampaineProductApi() ;
    if (response != null) {
      state = state.copyWith(response['data']);
    }
  }
}

class CampaineState {
  List listCampaine;
  CampaineState({this.listCampaine = const []});
  CampaineState copyWith(List newListData) {
    return CampaineState(listCampaine: newListData);
  }
}
