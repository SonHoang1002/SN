import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../providers/grow/grow_provider.dart';

class Payment extends ConsumerStatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  ConsumerState<Payment> createState() => _PaymentState();
}

class _PaymentState extends ConsumerState<Payment> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      dynamic transactions = ref.read(growControllerProvider).growTransactions;
      if (transactions == null || transactions.isEmpty) {
        ref.read(growControllerProvider.notifier).getGrowTransactions({});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic transactions = ref.watch(growControllerProvider).growTransactions;
    dynamic balance = transactions?["balance"];

    String formattedBalance =
        balance != null ? NumberFormat.decimalPattern().format(balance) : "--";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          height: 5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Số dư xu'),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/IconCoin.svg',
                            width: 40, height: 40, color: Colors.amber),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            formattedBalance,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 36),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Do something
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent[
                                400], // background (button) color// foreground (text) color
                            minimumSize: const Size(200, 40)),
                        child: const Text(
                          'Nạp',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 32.0),
          child: Divider(
            height: 16,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/IconCoin.svg',
                      width: 22, height: 22, color: Colors.grey),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Doanh thu quà tặng',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      '\$0',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                  Icon(
                    FontAwesomeIcons.chevronRight,
                    size: 12,
                  )
                ],
              )
            ],
          ),
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'FAQ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(width: 3),
                Icon(
                  FontAwesomeIcons.chevronRight,
                  size: 12,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
