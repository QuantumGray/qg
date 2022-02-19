import 'package:qg_flutter_base/presentation/presentation.dart';

final pAssets = Provider((ref) => Assets());

class Assets {
  final icons = _Icons();
  final images = _Images();
  final animations = _Animations();
  final colors = _Colors();
  final gradients = _Gradients();
}

class _Icons {}

class _Images {}

class _Animations {}

class _Colors {}

class _Gradients {}
