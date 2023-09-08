import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';

class GroupListSchedule extends ConsumerStatefulWidget {
  final dynamic groupDetail;
  const GroupListSchedule({super.key, required this.groupDetail});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupListScheduleState();
}

class _GroupListScheduleState extends ConsumerState<GroupListSchedule> {
  dynamic data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    data = await GroupApi().fetchScheduledStatus(widget.groupDetail["id"]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: AppBarTitle(
              title: data != null
                  ? 'Bài viết đã lên lịch (${data.length})'
                  : "Bài viết đã lên lịch"),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              data == null
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Center(
                            child: SkeletonCustom().postSkeleton(context));
                      })
                  : data.length == 0
                      ? const Center(
                          child: Text("Chưa có bài đăng nào"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Post(
                                  type: postSchedule,
                                  post: data[index]["status"],
                                  haveSuggest: false,
                                  isInGroup: true,
                                  groupData: widget.groupDetail,
                                  isHiddenFooter: true,
                                  isHiddenCrossbar: true,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: ButtonPrimary(
                                        label: "Đổi lịch",
                                        isGrey: true,
                                      )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: ButtonPrimary(
                                        label: "Đăng ngay",
                                        colorText: white,
                                      ))
                                    ],
                                  ),
                                ),
                                const CrossBar(
                                  height: 10,
                                )
                              ],
                            );
                          })
            ],
          ),
        ));
  }
}
