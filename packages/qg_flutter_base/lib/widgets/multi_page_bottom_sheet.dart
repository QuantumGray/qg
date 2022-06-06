import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

class MultiPageBottomSheet extends StatelessWidget {
  final List<Widget> pages;
  final ValueListenable<int> pageIndexListenable;

  const MultiPageBottomSheet({
    Key? key,
    required this.pages,
    required this.pageIndexListenable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: pageIndexListenable,
      builder: (context, value, _) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SafeArea(
              bottom: false,
              child: Scaffold(
                body: CustomMultiChildLayout(
                  delegate: _BottomSheetContainerLayoutDelegate(),
                  children: [
                    LayoutId(
                      id: '1',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.maybePop(context),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    LayoutId(
                      id: '2',
                      child: _MultiPageBottomSheetScaffold(
                        pages: pages,
                        index: value,
                        pageIndexListenable: pageIndexListenable,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BottomSheetContainerLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final Size bottomSheetContainerSize = layoutChild(
      '2',
      BoxConstraints(
        maxHeight: size.height * .9,
        minHeight: size.height * .4,
        maxWidth: size.width,
        minWidth: size.width,
      ),
    );

    positionChild(
      '1',
      Offset(
        0,
        size.height - bottomSheetContainerSize.height,
      ),
    );

    layoutChild(
      '2',
      BoxConstraints(
        maxWidth: size.width,
        maxHeight: size.height - bottomSheetContainerSize.height,
      ),
    );
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}

class _MultiPageBottomSheetScaffold extends ConsumerStatefulWidget {
  final List<Widget> pages;
  final int index;
  final ValueListenable<int> pageIndexListenable;

  const _MultiPageBottomSheetScaffold({
    Key? key,
    required this.pages,
    required this.index,
    required this.pageIndexListenable,
  }) : super(key: key);

  @override
  __MultiPageBottomSheetScaffoldState createState() =>
      __MultiPageBottomSheetScaffoldState();
}

class __MultiPageBottomSheetScaffoldState
    extends ConsumerState<_MultiPageBottomSheetScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ref.read(pDefaults).pageTransitionDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_MultiPageBottomSheetScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    final forwardMove = oldWidget.index < widget.index;
    if (forwardMove) {
      _addPage(animate: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget get page => widget.pages[widget.index];

  void _addPage({required bool animate}) {
    _animationController
      ..reset()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {}
      });
    if (animate) {
      _animationController.forward();
    } else {
      _animationController.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return page;
  }
}
