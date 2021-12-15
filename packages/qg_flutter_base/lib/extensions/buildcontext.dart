import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:qg_flutter_base/presentation/widgets/platform_icons.dart';

extension BuildContextY on BuildContext {
  ThemeData get theme => Theme.of(this);

  T? dependOn<T extends InheritedWidget>() =>
      dependOnInheritedWidgetOfExactType<T>();

  Widget? findWidget<T extends Widget>() => findAncestorWidgetOfExactType<T>();

  T? findState<T extends State<StatefulWidget>>() =>
      findAncestorStateOfType<T>();

  void visitUpwardsElements(bool Function(Element element) visitor) =>
      visitAncestorElements(visitor);

  void visitDownwardsElements(void Function(Element element) visitor) =>
      visitChildElements(visitor);

  RenderObject renderObject() => findRenderObject()!;

  Size size() => this.size!;
  double width() => size().width;
  double height() => size().height;

  void rebuildElement<T extends Element>() {
    visitAncestorElements((_element) {
      if (_element is T) {
        _element.owner?.scheduleBuildFor(_element);
        return false;
      }
      return true;
    });
  }

  BuildOwner owner() => this.owner!;

  PlatformIcons platformIcons() => PlatformIcons(this);

  IDefaults defaults(WidgetRef ref) => ref.read(pDefaults);
}
