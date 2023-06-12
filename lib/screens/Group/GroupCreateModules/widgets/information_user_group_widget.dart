import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

class InformationUserGroupWidget extends StatelessWidget {
  final Widget? prefixWidget;
  final List<Widget> contentWidget;
  final Widget? suffixWidget;
  final Color? changeBackground;
  final EdgeInsetsGeometry? padding;

  const InformationUserGroupWidget(this.contentWidget,
      {this.prefixWidget,
      this.suffixWidget,
      this.changeBackground,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            // height: 77,
            // color: Colors.red,
            // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: padding ?? EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
                color: changeBackground ?? Colors.grey[900],
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
                        // fit: FlexFit.tight,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: contentWidget.map((e) => e).toList()),
                        ),
                      ),
                      suffixWidget != null
                          ? Flexible(
                              flex: 4, child: suffixWidget ?? Container())
                          : Container(),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
