import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowPositionFill {
  bool showPositionFillStatus;

  ShowPositionFill({
    this.showPositionFillStatus = false,
  });

  ShowPositionFill copyWith({
    bool newPosition = false,
  }) {
    return ShowPositionFill(
      showPositionFillStatus: newPosition,
    );
  }
}

final showPositionFillProvider =
    StateNotifierProvider<ShowPositionFillController, ShowPositionFill>(
        (ref) => ShowPositionFillController());

class ShowPositionFillController extends StateNotifier<ShowPositionFill> {
  ShowPositionFillController() : super(ShowPositionFill());

  setShowPositionFill(bool newStatus) {
    state = state.copyWith(newPosition: newStatus);
  }
}

// Card(
    //     elevation: 0,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     color: widget.type == postWatch
    //         ? Colors.grey.shade800
    //         : Theme.of(context).colorScheme.background,
    //     child: SizedBox(
    //       height: getTextSize(widget.textController!.text)!.height,
    //       child: TextFormField(
    //         focusNode: widget.focusNode,
            // controller: widget.textController,
            // minLines: widget.minLines,
            // maxLines: widget.maxLines,
            // initialValue: widget.initialValue,
            // autofocus: widget.autofocus,
            // textAlignVertical: TextAlignVertical.center,
            // keyboardType: TextInputType.multiline,
            // textCapitalization: TextCapitalization.sentences,
            // cursorColor: Theme.of(context).textTheme.displayLarge?.color,
            // onChanged: (value) {
            //   widget.handleGetValue!(value);
            // },
    //         decoration: InputDecoration(
    //           isDense: widget.isDense ?? false,
    //           border: InputBorder.none,
    //           contentPadding: EdgeInsets.only(
    //             left: 12,
    //             // top: 10,
    //             // bottom: 10,
    //           ),
    //           suffixIcon: widget.suffixIcon,
    //           hintText: widget.hintText,
    //           hintStyle: TextStyle(
    //               fontSize: 14,
    //               color: widget.type == postWatch ? Colors.white : null),
    //           labelText: widget.label,
    //           focusColor: primaryColor,
    //           helperText: widget.helperText,
    //           errorText: widget.errorText,
    //         ),
    //       ),
    //     ));
 
