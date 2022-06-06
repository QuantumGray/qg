import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChoiceDialog extends HookConsumerWidget {
  final String? title;
  final String? description;
  final String? leftLabel;
  final String? rightLabel;
  final dynamic Function()? onRightClick;
  final dynamic Function()? onLeftClick;
  final Future<bool> Function()? onWillPop;

  const ChoiceDialog({
    Key? key,
    this.title,
    this.description,
    this.leftLabel,
    this.rightLabel,
    this.onRightClick,
    this.onLeftClick,
    this.onWillPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: onWillPop ?? () => SynchronousFuture(false),
      child: AlertDialog(
        title: title != null ? Text(title!) : null,
        content: description != null
            ? Text(
                description!,
              )
            : null,
        actions: [
          TextButton(
            child: Text(leftLabel ?? 'Yes'),
            onPressed: () {
              Navigator.pop(context, onLeftClick?.call());
            },
          ),
          TextButton(
            child: Text(rightLabel ?? 'No'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}
