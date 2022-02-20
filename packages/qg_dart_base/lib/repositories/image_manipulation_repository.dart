import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';
import 'package:riverpod/riverpod.dart';

final pImageManipulationRepository = Provider<ImageManipulationRepository>(
  (ref) => ImageManipulationRepository(),
);

class ImageManipulationRepository {
  BlurHash Function(
    Image image, {
    int numCompX,
    int numCompY,
  }) get encodeBlurhash => BlurHash.encode;
}
