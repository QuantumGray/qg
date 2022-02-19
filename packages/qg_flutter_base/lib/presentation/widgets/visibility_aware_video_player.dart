import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VisbilityAwareVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final double visibleFractionThreshold;

  const VisbilityAwareVideoPlayer({
    Key? key,
    required this.controller,
    this.visibleFractionThreshold = .8,
  }) : super(key: key);

  @override
  _VisbilityAwareVideoPlayerState createState() =>
      _VisbilityAwareVideoPlayerState();
}

class _VisbilityAwareVideoPlayerState extends State<VisbilityAwareVideoPlayer> {
  late VideoPlayerController controller;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    _initFuture = _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    await controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(''),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction > widget.visibleFractionThreshold) {
          controller.play();
        } else {
          controller.pause();
        }
      },
      child: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          );
        },
      ),
    );
  }
}
