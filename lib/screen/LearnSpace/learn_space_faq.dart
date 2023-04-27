import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/learn_space_api.dart';

import '../../providers/learn_space/learn_space_provider.dart';

class LearnSpaceFAQ extends ConsumerStatefulWidget {
  final dynamic courseDetail;
  const LearnSpaceFAQ({super.key, this.courseDetail});

  @override
  ConsumerState<LearnSpaceFAQ> createState() => _LearnSpaceFAQState();
}

class _LearnSpaceFAQState extends ConsumerState<LearnSpaceFAQ> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textQuestion = TextEditingController(text: "");
  final TextEditingController _textAnswer = TextEditingController(text: "");
  List<CourseFAQ> _courseFAQ = [];
  var formData = {};
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesFAQ(widget.courseDetail['id']);
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
            children: [
              const Text('Câu hỏi thường gặp'),
              widget.courseDetail['course_relationships']['host_course']
                  ? TextButton(
                      onPressed: () {
                        _textQuestion.clear();
                        _textAnswer.clear();
                        showBarModalBottomSheet(
                            context: context,
                            builder: (context) => SingleChildScrollView(
                                  primary: true,
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SizedBox(
                                    height: 300,
                                    child: InkWell(
                                      onTap: () {
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                      },
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Center(
                                                    child: Text('Tạo câu hỏi')),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: TextFormField(
                                                  controller: _textQuestion,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Câu hỏi',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: TextFormField(
                                                  controller: _textAnswer,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Trả lời',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 16.0),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: Size(
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          45),
                                                      foregroundColor: Colors
                                                          .white, // foreground
                                                    ),
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        final dataQuestion =
                                                            _textQuestion.text;
                                                        final dataAnswer =
                                                            _textAnswer.text;
                                                        try {
                                                          await LearnSpaceApi()
                                                              .createFAQCoursesApi(
                                                            widget.courseDetail[
                                                                'id'],
                                                            {
                                                              "question":
                                                                  dataQuestion,
                                                              "answer":
                                                                  dataAnswer
                                                            },
                                                          );
                                                          await ref
                                                              .read(
                                                                  learnSpaceStateControllerProvider
                                                                      .notifier)
                                                              .getListCoursesFAQ(
                                                                  widget.courseDetail[
                                                                      'id']);
                                                          setState(() {
                                                            _courseFAQ = ref
                                                                .watch(
                                                                    learnSpaceStateControllerProvider)
                                                                .courseFAQ
                                                                .map((json) =>
                                                                    CourseFAQ
                                                                        .fromJson(
                                                                            json))
                                                                .toList();
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      }
                                                    },
                                                    child: const Text(
                                                        'Tạo câu hỏi')),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ));
                      },
                      child: const Text('Tạo câu hỏi'))
                  : const SizedBox()
            ],
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
