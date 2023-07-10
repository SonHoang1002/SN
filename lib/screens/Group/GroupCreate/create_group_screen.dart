import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/screens/Group/GroupCreate/text_field_group.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Tạo nhóm'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Tên',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              const TextFieldGroup(
                label: 'Đặt tên nhóm',
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Quyền riêng tư',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showBarModalBottomSheet(
                      barrierColor: Colors.transparent,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      context: context,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setStateful) {
                            return Container();
                          }));
                },
                child: const TextFieldGroup(
                  label: 'Chọn quyền riêng tư',
                  initialValue: 'Công khai',
                  readOnly: true,
                  enabled: false,
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
