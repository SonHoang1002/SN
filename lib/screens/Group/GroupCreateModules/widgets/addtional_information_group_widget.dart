import 'package:flutter/material.dart';

class AddtionalInformationGroupWidget extends StatelessWidget {
  final Widget? prefixWidget;
  final List<Widget> contentWidget;
  final Widget? suffixWidget;

  const AddtionalInformationGroupWidget(
      {super.key,
      this.prefixWidget,
      required this.contentWidget,
      this.suffixWidget});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            // height: 77,
            // color: Colors.red,
            // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                // prefixWidget != null
                //     ? Container(
                //         width: 50,
                //         alignment: Alignment.topCenter,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [prefixWidget!],
                //         ),
                //       )
                //     : Container(),
                prefixWidget != null
                    ? Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: prefixWidget ?? Container(),
                      )
                    : Container(),
                Flexible(
                  flex: 10,
                  child: Container(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: contentWidget.map((e) => e).toList()),
                  ),
                ),
                suffixWidget != null
                    ? Flexible(
                        flex: 2,
                        child: suffixWidget ?? Container(),
                      )
                    : Container(),
              ],
            )),
      ],
    );
  }
}
