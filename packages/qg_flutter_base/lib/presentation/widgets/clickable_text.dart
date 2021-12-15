// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickableTextSpan extends TextSpan {
  final TextStyle? style;
  final String text;
  final VoidCallback? onTap;

  void foo() {}

  ClickableTextSpan({
    required this.text,
    this.style,
    this.onTap,
  }) : super(
          text: text,
          style: style,
          recognizer: TapGestureRecognizer()..onTap = onTap,
        );
}
