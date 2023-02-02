import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HideGroupProvider with ChangeNotifier {
  String selection = "Hiển thị";
  setHideGroupProvider(String value) {
    selection = value;
    notifyListeners();
  }

  get getHideGroupProvider => selection;
}

class HideGroupBloc extends Bloc<HideGroupEvent, HideGroupState> {
  HideGroupBloc() : super(InitHideGroupState()) {
    on<UpdateHideGroupEvent>((event, emit) {
      emit(UpdateHideGroupState(event.selection));
      print(state.selection);
    });
  }
}

abstract class HideGroupEvent {}

class UpdateHideGroupEvent extends HideGroupEvent {
  final String selection;
  UpdateHideGroupEvent(this.selection) : super();
}

abstract class HideGroupState {
  final String selection;
  HideGroupState(this.selection);
}

class InitHideGroupState extends HideGroupState {
  InitHideGroupState() : super("Hiển thị");
}

class UpdateHideGroupState extends HideGroupState {
  final String _selection;
  UpdateHideGroupState(this._selection) : super(_selection);
}
