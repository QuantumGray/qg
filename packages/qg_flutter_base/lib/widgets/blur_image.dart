import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:qg_flutter_base/extensions/buildcontext.dart';

class BlurImage extends ConsumerStatefulWidget {
  final String blurhash;
  final ImageProvider image;
  final BoxFit? fit;
  final double width;
  final double height;

  final BoxDecoration decoration;

  static const double defaultCircleHeight = 40;
  static const double defaultCircleWidth = 40;

  const BlurImage({
    Key? key,
    required this.blurhash,
    required this.image,
    this.fit,
    this.height = 40,
    this.width = 40,
  })  : decoration = _defaultDecoration,
        super(key: key);

  BlurImage.circle({
    Key? key,
    required this.blurhash,
    required this.image,
    this.fit,
    this.height = BlurImage.defaultCircleHeight,
    this.width = BlurImage.defaultCircleWidth,
  })  : decoration = _defaultDecoration.copyWith(shape: BoxShape.circle),
        super(key: key);

  BlurImage.card({
    Key? key,
    required this.blurhash,
    required this.image,
    this.fit,
    this.height = 40,
    this.width = 40,
  })  : decoration = _defaultDecoration.copyWith(
          borderRadius: BorderRadius.circular(20),
        ),
        super(key: key);

  const BlurImage.rect({
    Key? key,
    required this.blurhash,
    required this.image,
    this.fit,
    this.height = 40,
    this.width = 40,
  })  : decoration = _defaultDecoration,
        super(key: key);

  static const _defaultDecoration = BoxDecoration();

  @override
  _BlurImageState createState() => _BlurImageState();
}

class _BlurImageState extends ConsumerState<BlurImage> {
  @override
  void initState() {
    super.initState();
    // if (widget.image is NetworkImage) {
    //   preCache
    // }
    //  precacheImage(widget.image, context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? get fileMimeType =>
      lookupMimeType((widget.image as FileImage).file.path);

  @override
  Widget build(BuildContext context) {
    final defaults = context.defaults(ref);
    return AnimatedSwitcher(
      duration: defaults.animationDuration,
      child: Container(
        decoration: widget.decoration,
        clipBehavior: Clip.hardEdge,
        height: widget.height,
        width: widget.height,
        child: FittedBox(
          fit: BoxFit.fill,
          child: FadeInImage(
            fit: widget.fit,
            fadeInDuration: defaults.animationDuration,
            fadeInCurve: defaults.animationCurve,
            fadeOutCurve: defaults.animationCurve,
            placeholder: BlurHashImage(widget.blurhash),
            image: widget.image,
          ),
        ),
      ),
    );
  }
}
