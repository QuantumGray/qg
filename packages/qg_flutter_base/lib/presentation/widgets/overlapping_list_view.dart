import 'package:flutter/material.dart';

class OverlappingListView extends StatelessWidget {
  final double overlapFactor;
  final List<Widget> children;
  final Axis? scrollDirection;

  const OverlappingListView({
    Key? key,
    required this.children,
    this.overlapFactor = .7,
    this.scrollDirection,
  }) : super(key: key);

  OverlappingListView.avatars({
    Key? key,
    required List<ImageProvider> images,
    this.overlapFactor = .7,
    this.scrollDirection,
  })  : children = images
            .map<Widget>(
              (provider) => CircleAvatar(
                backgroundImage: provider,
              ),
            )
            .toList(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: scrollDirection ?? Axis.vertical,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return Align(
          widthFactor: overlapFactor,
          child: children[index],
        );
      },
    );
  }
}
