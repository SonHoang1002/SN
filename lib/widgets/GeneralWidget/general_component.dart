import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class GeneralComponent extends StatelessWidget {
  final Widget? prefixWidget;
  final List<Widget> contentWidget;
  final Widget? suffixWidget;
  final Color? changeBackground;
  final EdgeInsetsGeometry? padding;
  final double? borderRadiusValue;
  final int? suffixFlexValue;
  final int? preffixFlexValue;
  final Color? borderColor;

  final Function? function;
  final bool? isHaveBorder; 
  final EdgeInsetsGeometry? margin;
  final CrossAxisAlignment? preffixCrossAxisAlignment;

  const GeneralComponent(this.contentWidget,
      {super.key,
      this.prefixWidget,
      this.suffixWidget,
      this.changeBackground,
      this.padding,
      this.borderRadiusValue,
      this.suffixFlexValue,
      this.preffixFlexValue,
      this.function,
      this.isHaveBorder,
      this.borderColor,
      this.margin,
      this.preffixCrossAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function != null ? function!() : null;
      },
      child: Stack(
        children: [
          Wrap(
            children: [
              Container(
                  margin: margin ?? EdgeInsets.zero,
                  padding: padding ?? const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                      color: changeBackground ?? Theme.of(context).cardColor,
                      border: isHaveBorder == true
                          ? Border.all(
                              color: borderColor ?? greyColor, width: 0.6)
                          : null,
                      borderRadius: BorderRadius.all(
                          Radius.circular(borderRadiusValue ?? 7))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment:
                        preffixCrossAxisAlignment ?? CrossAxisAlignment.center,
                    children: [
                      prefixWidget != null &&
                              prefixWidget != Container() &&
                              prefixWidget != const SizedBox()
                          ? Flexible(
                              flex: preffixFlexValue ?? 2,
                              child: prefixWidget ?? Container(),
                            )
                          : Container(),
                      Flexible(
                        flex: 10,
                        child: InkWell(
                          onTap: () {
                            function != null ? function!() : null;
                          },
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: contentWidget.map((itemWidget) {
                                        return itemWidget;
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
                      ),
                    ],
                  )),
            ],
          ),
          InkWell(
              onTap: () {
                function != null ? function!() : null;
              },
              child: Column(
                children: [Container(color: red)],
              ))
        ],
      ),
    );
  }
}
