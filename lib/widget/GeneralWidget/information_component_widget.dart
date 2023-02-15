import 'package:flutter/material.dart';

class GeneralComponent extends StatelessWidget {
  final Widget? prefixWidget;
  final List<Widget> contentWidget;
  final Widget? suffixWidget;
  final Color? changeBackground;
  final EdgeInsetsGeometry? padding;
  final double? borderRadiusValue;
  final int? suffixFlexValue;
  final Function? function;

  const GeneralComponent(this.contentWidget,
      {this.prefixWidget,
      this.suffixWidget,
      this.changeBackground,
      this.padding,
      this.borderRadiusValue,
      this.suffixFlexValue,
      this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function != null ? function!() : null;
      },
      child: Wrap(
        children: [
          Container(
              // height: 77,
              // color: Colors.red,
              // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: padding ?? EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  color: changeBackground ?? Colors.grey[900],
                  borderRadius: BorderRadius.all(
                      Radius.circular(borderRadiusValue ?? 7))),
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
                  prefixWidget != null &&
                          prefixWidget != Container() &&
                          prefixWidget != const SizedBox()
                      ? Flexible(
                          flex: 2,
                          child: prefixWidget ?? Container(),
                        )
                      : Container(),
                  Flexible(
                    flex: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 20,
                          child: Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: contentWidget.map((itemWidget) {
                                  // if (itemWidget != SizedBox() &&
                                  //     itemWidget != Container()) {
                                  return itemWidget;
                                  // }
                                  // return SizedBox();
                                }).toList()),
                          ),
                        ),
                        suffixWidget != null
                            ? Flexible(
                                flex: suffixFlexValue ?? 4,
                                child: suffixWidget ?? Container())
                            : Container(),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
