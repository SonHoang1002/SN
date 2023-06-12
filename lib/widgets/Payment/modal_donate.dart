// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

class ModalPayment extends ConsumerStatefulWidget {
  String title;
  String buttonTitle;
  final dynamic updateApi;
  ModalPayment(
      {Key? key,
      required this.title,
      required this.buttonTitle,
      required this.updateApi})
      : super(key: key);

  @override
  ConsumerState<ModalPayment> createState() => _ModalPaymentState();
}

const paymentValue = [
  {"value": 50},
  {"value": 100},
  {"value": 200},
  {"value": 500},
  {"value": 1000},
  {"value": 2000},
];

class _ModalPaymentState extends ConsumerState<ModalPayment> {
  int selectedItemIndex = -1;
  bool _isCustomize = false;
  TextEditingController controller = TextEditingController(text: "");
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () =>
            ref.read(growControllerProvider.notifier).getGrowTransactions({}));
  }

  @override
  Widget build(BuildContext context) {
    var growTransactions = ref.watch(growControllerProvider).growTransactions;
    final theme = pv.Provider.of<ThemeManager>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _isCustomize = false;
          controller.text = '';
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: theme.isDarkMode ? Colors.black : Colors.white,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              builder: (context) => SingleChildScrollView(
                                    primary: true,
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Container(),

                                    /// modal nạp
                                  ));
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            color: greyColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Nạp',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SvgPicture.asset('assets/IconCoin.svg',
                                    width: 22,
                                    height: 22,
                                    color: colorWord(context))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // change this to 3
                    childAspectRatio: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16),
                itemCount: paymentValue.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      decoration: BoxDecoration(
                          color: selectedItemIndex == index
                              ? secondaryColor
                              : greyColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                          border: selectedItemIndex == index
                              ? Border.all(width: 1, color: greyColor)
                              : null),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedItemIndex = index;
                            _isCustomize = false;
                            controller.text = '';
                          });
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${paymentValue[index]['value']}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isCustomize = !_isCustomize;
                      selectedItemIndex = -1;
                    });
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: !_isCustomize
                        ? const Text(
                            'Tuỳ chỉnh',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : TextFormField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly // Only allow digits
                            ],
                            maxLines: 1,
                            controller: controller,
                            style: TextStyle(color: colorWord(context)),
                            onChanged: (value) {},
                            autofocus: true,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: ''),
                          ),
                  ),
                ),
              ),
            ),
            Divider(height: 20, thickness: 1, color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: InkWell(
                onTap: () {
                  var value =
                      '${!_isCustomize && selectedItemIndex != -1 ? paymentValue[selectedItemIndex]['value'] : controller.text}';
                  var balance = (growTransactions['balance'] / 1000);
                  try {
                    if (int.parse(value) > 0 || value.isEmpty) {
                      if (int.parse(value) > balance) {
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            context: context,
                            isScrollControlled: true,
                            isDismissible: true,
                            builder: (context) => SingleChildScrollView(
                                  primary: true,
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(),

                                  /// modal nạp
                                ));
                      } else {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text('Xác nhận thanh toán',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              content: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              'Bạn có chắc muốn ${widget.buttonTitle} dự án với ${!_isCustomize && selectedItemIndex != -1 ? paymentValue[selectedItemIndex]['value'] : controller.text}',
                                          style: TextStyle(
                                              color: colorWord(context),
                                              fontWeight: FontWeight.w400)),
                                      const TextSpan(
                                        text: ' ',
                                      ),
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 1.0),
                                          child: SvgPicture.asset(
                                              'assets/IconCoin.svg',
                                              width: 14,
                                              height: 14,
                                              color: secondaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: const Text('Huỷ'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _isCustomize = false;
                                      controller.text = '';
                                    });
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text(widget.buttonTitle),
                                  onPressed: () {
                                    widget.updateApi({
                                      "amount": !_isCustomize &&
                                              selectedItemIndex != -1
                                          ? paymentValue[selectedItemIndex]
                                              ['value']
                                          : controller.text
                                    });
                                    Navigator.of(context)
                                      ..pop()
                                      ..pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${widget.buttonTitle} dự án thành công'),
                                        backgroundColor: secondaryColor,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        width: 300.0, // Width of the SnackBar.
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical:
                                                16.0 // Inner padding for SnackBar content.
                                            ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text('Lỗi nhập số tiền',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                            'Số tiền ${widget.buttonTitle.toLowerCase()} phải lớn hơn 0',
                                        style: TextStyle(
                                            color: colorWord(context),
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text('Xác nhận'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _isCustomize = false;
                                    controller.text = '';
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } on FormatException {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text('Lỗi nhập số tiền',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          content: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          'Vui lòng nhập số tiền hoặc chọn số tiền bạn muốn ${widget.buttonTitle.toLowerCase()}',
                                      style: TextStyle(
                                          color: colorWord(context),
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text('Xác nhận'),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _isCustomize = false;
                                  controller.text = '';
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: greyColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.buttonTitle,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose(); // dispose the controller when no longer needed
    super.dispose();
  }
}
