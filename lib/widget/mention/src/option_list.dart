part of social_mention;

class OptionList extends StatelessWidget {
  OptionList({
    required this.data,
    required this.onTap,
    required this.suggestionListHeight,
    this.suggestionBuilder,
    this.suggestionListDecoration,
  });

  final Widget Function(dynamic, int)? suggestionBuilder;

  final List data;

  final Function(dynamic) onTap;

  final double suggestionListHeight;

  final BoxDecoration? suggestionListDecoration;

  @override
  Widget build(BuildContext context) {
    return data.isNotEmpty
        ? Container(
            decoration: suggestionListDecoration ??
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            constraints: BoxConstraints(
              maxHeight: suggestionListHeight,
              minHeight: 0,
            ),
            child: SingleChildScrollView(
              child: Column(
                  children: List.generate(
                      data.length,
                      (index) => GestureDetector(
                            onTap: () {
                              onTap(data[index]);
                            },
                            child: suggestionBuilder != null
                                ? suggestionBuilder!(data[index], index)
                                : Container(
                                    color: Colors.blue,
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                      data[index]['name'],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                          ))),
            ),
          )
        : Container();
  }
}
