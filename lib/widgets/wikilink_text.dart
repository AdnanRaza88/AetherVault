import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WikilinkText extends StatelessWidget {
  final String content;
  final void Function(String id) onLinkTap;

  const WikilinkText({
    super.key,
    required this.content,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\[\[([^\]|]+)(?:\|([^\]]*))?\]\]');
    int last = 0;

    for (final match in regex.allMatches(content)) {
      if (match.start > last) {
        spans.add(TextSpan(text: content.substring(last, match.start)));
      }
      final target = match.group(1)!.trim();
      final alias = match.group(2)?.trim();
      spans.add(
        TextSpan(
          text: alias?.isNotEmpty == true ? alias : target,
          style: const TextStyle(
            color: Color(0xFFA78BFA),
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => onLinkTap(target),
        ),
      );
      last = match.end;
    }

    if (last < content.length) {
      spans.add(TextSpan(text: content.substring(last)));
    }

    return SelectableText.rich(
      TextSpan(
        style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
        children: spans,
      ),
    );
  }
}
