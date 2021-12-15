import 'package:flutter/material.dart';

class SlidingTabBarItem {
  final String Function(BuildContext localizations) text;
  final VoidCallback? onTap;

  SlidingTabBarItem({
    required this.text,
    this.onTap,
  });
}

class SlidingTabBar extends StatefulWidget {
  final List<SlidingTabBarItem> items;
  final BoxConstraints? constraints;
  final void Function(int tab)? onTabChanged;
  final void Function(int tab)? onTabTapped;
  final TabController? controller;

  const SlidingTabBar({
    Key? key,
    required this.items,
    this.onTabChanged,
    this.onTabTapped,
    this.constraints,
    this.controller,
  }) : super(key: key);

  @override
  _SlidingTabBarState createState() => _SlidingTabBarState();
}

class _SlidingTabBarState extends State<SlidingTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.constraints?.maxHeight,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: widget.constraints ?? const BoxConstraints.tightFor(),
        child: TabBar(
          controller: widget.controller,
          indicator: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: Colors.black,
          tabs: widget.items
              .map(
                (item) => Tab(
                  child: FractionallySizedBox(
                    child: Center(
                      child: Text(item.text(context)),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// import 'package:qg_flutter_base/base/constants/constants_ui.dart';
// import 'package:flutter/material.dart';

// class AppTabBar extends StatefulWidget {
//   final TabController? tabController;
//   final List<String> items;

//   const AppTabBar({
//     Key? key,
//     this.tabController,
//     required this.items,
//   }) : super(key: key);

//   @override
//   _AppTabBarState createState() => _AppTabBarState();
// }

// class _AppTabBarState extends State<AppTabBar> {
//   @override
//   Widget build(BuildContext context) {
//     return TabBar(
//       indicator: const BoxDecoration(
//         color: Colors.grey,
//         borderRadius: ConstantsUi.defaultBorderRadius,
//       ),
//       controller: widget.tabController,
//       indicatorSize: TabBarIndicatorSize.tab,
//       unselectedLabelColor: Colors.black,
//       labelPadding: EdgeInsets.zero,
//       indicatorWeight: 3,
//       tabs: widget.items
//           .map(
//             (title) => Tab(
//               iconMargin: EdgeInsets.zero,
//               child: FractionallySizedBox(
//                 child: Center(
//                   child: Text(title),
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }
// }
