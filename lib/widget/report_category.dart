import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/data/report.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class ReportCategory extends StatelessWidget {
  final dynamic entityReport;
  final String entityType;
  const ReportCategory({Key? key, this.entityReport, required this.entityType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const AppBarTitle(title: "Báo cáo"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Báo cáo vấn đề',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              const SizedBox(
                height: 4.0,
              ),
              const Text(
                'Nến bạn cho rằng đây là một vấn đề không an toàn, vi phạm nguyên tắc cộng đồng, hãy chọn vấn đề ở dưới để báo cáo với chúng tôi.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(
                height: 8.0,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: true,
                  itemCount: reportCategories.length,
                  itemBuilder: (context, index) => ReportItem(
                      entityReport: entityReport,
                      entityType: entityType,
                      index: index,
                      report: reportCategories[index]))
            ],
          ),
        ),
      ),
    );
  }
}

class ReportItem extends StatelessWidget {
  final dynamic report;
  final int index;
  final dynamic entityReport;
  final String entityType;
  const ReportItem({
    super.key,
    this.report,
    required this.index,
    this.entityReport,
    required this.entityType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
            showBarModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => ReportChildren(
                    report: report,
                    entityReport: entityReport,
                    entityType: entityType));
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 38,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              report['text'],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        index + 1 == reportCategories.length
            ? const SizedBox()
            : const CrossBar(
                height: 0.2,
              )
      ],
    );
  }
}

class ReportChildren extends ConsumerWidget {
  final dynamic report;
  final dynamic entityReport;
  final String entityType;
  const ReportChildren(
      {Key? key, this.report, this.entityReport, required this.entityType})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List children = report['children'] ?? [];

    handleReport() async {
      var data = {
        "account_id": entityReport['account']['id'],
        "status_ids": [entityReport['id']],
        "comment": "",
        "forward": false,
        "report_category_id": report['id']
      };

      var response = await PostApi().reportPostApi(jsonEncode(data));
      if (response != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Cảm ơn bạn đã gửi báo cáo, chúng tôi sẽ xem xét về nội dung này")));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Có lỗi xảy ra, thử lại sau")));
      }

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showBarModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ReportCategory(
                        entityReport: entityReport, entityType: entityType));
              },
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
            ),
            AppBarTitle(title: report['text']),
            Container()
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              children.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      itemCount: children.length,
                      itemBuilder: (context, index) => ReportItem(
                          index: index,
                          report: children[index],
                          entityReport: entityReport,
                          entityType: entityType))
                  : Column(
                      children: [
                        Html(
                          data: report['description'],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          height: 36,
                          child: ButtonPrimary(
                            label: "Báo cáo",
                            handlePress: () {
                              handleReport();
                            },
                            isPrimary: true,
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
