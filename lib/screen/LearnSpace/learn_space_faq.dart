import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/learn_space/learn_space_provider.dart';

class LearnSpaceFAQ extends ConsumerStatefulWidget {
  final String? id;
  const LearnSpaceFAQ({super.key, this.id});

  @override
  ConsumerState<LearnSpaceFAQ> createState() => _LearnSpaceFAQState();
}

class _LearnSpaceFAQState extends ConsumerState<LearnSpaceFAQ> {
  List<CourseFAQ> _courseFAQ = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesFAQ(widget.id);
        setState(() {
          _courseFAQ = ref
              .watch(learnSpaceStateControllerProvider)
              .courseFAQ
              .map((json) => CourseFAQ.fromJson(json))
              .toList();
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('FAQ'), Text('Tạo câu hỏi')],
          ),
        ),
        const Divider(
          height: 20,
          thickness: 1,
        ),
        _buildPanel(),
      ],
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _courseFAQ[index].isExpanded = !isExpanded;
        });
      },
      children: _courseFAQ.map((item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              title: Text(item.question),
            );
          },
          body: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            title: Text(item.answer),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class CourseFAQ {
  int id;
  int courseId;
  String question;
  String answer;
  String createdAt;
  String updatedAt;
  bool isExpanded;

  CourseFAQ({
    required this.id,
    required this.courseId,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
    this.isExpanded = false,
  });

  factory CourseFAQ.fromJson(Map<String, dynamic> json) {
    return CourseFAQ(
      id: json['id'],
      courseId: json['course_id'],
      question: json['question'],
      answer: json['answer'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
