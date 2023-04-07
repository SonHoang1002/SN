import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

class EventPublish extends StatefulWidget {
  final Function privateEventOnChanged;
  const EventPublish({super.key, required this.privateEventOnChanged});

  @override
  State<EventPublish> createState() => _EventPublishState();
}

class _EventPublishState extends State<EventPublish> {
  String defaultValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Quyền riêng tư của sự kiện'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 20,
            endIndent: 20,
            color: Colors.grey.withOpacity(0.5),
          ),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
                'Chọn xem ai có thể nhìn thấy và tham gia sự kiện này. Bạn có thể mời mọi người vào lúc khác.'),
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: typeVisibility.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 0.0),
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: 0),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(typeVisibility[index]['icon']),
                  ),
                  title: Text(
                    typeVisibility[index]['label'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(typeVisibility[index]['subLabel'],
                      style: const TextStyle(fontSize: 14)),
                  trailing: Radio(
                      activeColor: secondaryColor,
                      groupValue: defaultValue,
                      value: typeVisibility[index]['key'],
                      onChanged: (value) {
                        setState(() {
                          defaultValue = value.toString();
                        });
                      }),
                  onTap: () {
                    setState(() {
                      defaultValue = typeVisibility[index]['key'];
                    });
                  },
                );
              })),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 45),
                  foregroundColor: Colors.white, // foreground
                ),
                onPressed: () {
                  widget.privateEventOnChanged(defaultValue);
                  Navigator.pop(context);
                },
                child: const Text('Xong')),
          )
        ],
      ),
    );
  }
}
