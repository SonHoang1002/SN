part of social_mention;

/// A custom implementation of [TextEditingController] to support @ mention or other
/// trigger based mentions.
class AnnotationEditingController extends TextEditingController {
  Map<String, Annotation> _mapping;
  String? _pattern;

  // Generate the Regex pattern for matching all the suggestions in one.
  AnnotationEditingController(this._mapping) {
    _pattern = null;

    if (_mapping.keys.isNotEmpty) {
      var result = _mapping.keys.map((key) => RegExp.escape(key)).toList();
      result.sort((b, a) => a.toLowerCase().compareTo(b.toLowerCase()));
      var finalresult = result.join('|');
      _pattern = finalresult;
    }
  }

  /// Can be used to get the markup from the controller directly.
  String get markupText {
    final someVal = _mapping.isEmpty
        ? text
        : text.splitMapJoin(
            RegExp('$_pattern'),
            onMatch: (Match match) {
              final mention = _mapping[match[0]!] ??
                  _mapping[_mapping.keys.firstWhere((element) {
                    final reg = RegExp(element);

                    return reg.hasMatch(match[0]!);
                  })]!;

              // Default markup format for mentions
              if (!mention.disableMarkup) {
                return mention.markupBuilder != null
                    ? mention.markupBuilder!(
                        mention.trigger, mention.id!, mention.display!)
                    : '${mention.trigger}[${mention.id}]';
              } else {
                return match[0]!;
              }
            },
            onNonMatch: (String text) {
              return text;
            },
          );

    return someVal;
  }

  Map<String, Annotation> get mapping {
    return _mapping;
  }

  set mapping(Map<String, Annotation> mapping) {
    _mapping = mapping;

    var result = mapping.keys.map((key) => RegExp.escape(key)).toList();
    result.sort((b, a) => a.toLowerCase().compareTo(b.toLowerCase()));
    var finalresult = result.join('|');
    _pattern = finalresult;
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    var children = <InlineSpan>[];

    if (_pattern == null || _pattern == '()') {
      children.add(TextSpan(text: text, style: style));
    } else {
      text.splitMapJoin(
        RegExp('$_pattern'),
        onMatch: (Match match) {
          if (_mapping.isNotEmpty) {
            final mention = _mapping[match[0]!] ??
                _mapping[_mapping.keys.firstWhere((element) {
                  final reg = RegExp(element);

                  return reg.hasMatch(match[0]!);
                })]!;
            children.add(
              TextSpan(
                text: match[0],
                style: style!.merge(mention.style),
              ),
            );
          }

          return '';
        },
        onNonMatch: (String text) {
          children.add(TextSpan(text: text, style: style));
          return '';
        },
      );
    }

    return TextSpan(style: style, children: children);
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(() {
      String oldText = value.text;
      String newText = text;

      if (oldText.length > newText.length) {
        String deletedText = oldText.substring(newText.length, oldText.length);

        RegExp pattern = RegExp(r"\@\[[^\]]*\]$");
        if (pattern.hasMatch(deletedText)) {
          int startIndex = newText.lastIndexOf("@[");
          int endIndex = oldText.lastIndexOf("]", value.selection.baseOffset);

          if (startIndex >= 0 && endIndex >= 0 && endIndex > startIndex) {
            value = TextEditingValue(
              text: newText.substring(0, startIndex) +
                  oldText.substring(endIndex + 1),
              selection: TextSelection.collapsed(offset: startIndex),
            );
          }
        }
      }
      listener();
    });
  }
}
