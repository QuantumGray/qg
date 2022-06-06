import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'snackbar_config.freezed.dart';

@freezed
class SnackBarConfig with _$SnackBarConfig {
  const factory SnackBarConfig({
    String? actionLabel,
    VoidCallback? actionCallback,
    Duration? duration,
    VoidCallback? afterCallback,
    String? label,
    Widget? widget,
    Future? future,
    String? description,
  }) = _SnackBarConfig;

  const SnackBarConfig._();
}
