import 'package:flutter/material.dart';

extension ButtonStyleResolver on MaterialStateProperty {
  static MaterialStateProperty<T> map<T>({
    required T idle,
    T? disabled,
    T? dragged,
    T? error,
    T? focused,
    T? hovered,
  }) {
    return MaterialStateProperty.resolveWith<T>((_states) {
      if (_states.contains(MaterialState.disabled) && disabled != null) {
        return disabled;
      }
      if (_states.contains(MaterialState.dragged) && dragged != null) {
        return dragged;
      }
      if (_states.contains(MaterialState.error) && error != null) {
        return error;
      }
      if (_states.contains(MaterialState.focused) && focused != null) {
        return focused;
      }
      if (_states.contains(MaterialState.hovered) && hovered != null) {
        return hovered;
      }
      return idle;
    });
  }
}
