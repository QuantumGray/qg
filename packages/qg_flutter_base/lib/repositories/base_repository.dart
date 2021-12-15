import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseRepository {
  BaseRepository(this.read);
  final Reader read;
}
