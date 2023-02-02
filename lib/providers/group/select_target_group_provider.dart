import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTargetGroupProvider with ChangeNotifier {
  List<bool> list = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  setSelectTargetGroupProvider(List<bool> newlist) {
    list = newlist;
    notifyListeners();
  }

  get getSelectTargetGroupProvider => list;
}

class SelectTargetGroupBloc
    extends Bloc<SelectTargetGroupEvent, SelectTargetGroupState> {
  SelectTargetGroupBloc() : super(InitSelectTargetGroupState()) {
    on<UpdateSelectTargetGroupEvent>((event, emit) {
      emit(UpdateSelectTargetGroupState(event.list));
      state.list.forEach((element) {
        print(element);
      });
    });
  }
}

abstract class SelectTargetGroupEvent {}

class UpdateSelectTargetGroupEvent extends SelectTargetGroupEvent {
  final List<bool> list;
  UpdateSelectTargetGroupEvent(this.list) : super();
}

abstract class SelectTargetGroupState {
  final List<bool> list;
  SelectTargetGroupState(this.list);
}

class InitSelectTargetGroupState extends SelectTargetGroupState {
  InitSelectTargetGroupState()
      : super([
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
        ]);
}

class UpdateSelectTargetGroupState extends SelectTargetGroupState {
  final List<bool> list;
  UpdateSelectTargetGroupState(this.list) : super(list);
}
