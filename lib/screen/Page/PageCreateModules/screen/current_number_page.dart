import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentNumberPageCubit extends Cubit<int> {
  CurrentNumberPageCubit() : super(1);
  void updateCurrentNumberPageCubit(int number) {
    emit(number);
    // print("current number page :${number}");
  }
}
