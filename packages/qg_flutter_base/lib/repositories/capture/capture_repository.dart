import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';

final pCaptureRepository =
    Provider<CaptureRepository>((ref) => CaptureRepository(ref.read));

class CaptureRepository extends BaseRepository {
  CaptureRepository(Reader read) : super(read);

  Future<void> shareImage(
    BuildContext context,
    Widget widget,
    Future<void> Function(
      File file,
      Size size,
    )
        share,
  ) async {
    final size = MediaQuery.of(context).size;
    final bytes = await _createImageFromWidget(
      widget,
      logicalSize: const Size(1080, 1920),
      imageSize: const Size(1080, 1920),
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/share_image.png');
    await file.writeAsBytes(bytes);
    await share(file, size);
  }

  Future<Uint8List> _createImageFromWidget(
    Widget widget, {
    Size? logicalSize,
    Size? imageSize,
  }) async {
    final repaintBoundary = RenderRepaintBoundary();

    logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
    imageSize ??= ui.window.physicalSize;

    assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    const _devicePixelRatio = 1.01;

    final renderView = RenderView(
      window: ui.window,
      child: RenderPositionedBox(
        // ignore: avoid_redundant_argument_values
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: _devicePixelRatio,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(
      pixelRatio: imageSize.width / logicalSize.width,
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
    // TODO: implement init
  }
}
