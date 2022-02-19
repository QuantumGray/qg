import 'dart:async';
import 'package:shelf/shelf.dart';

abstract class BaseAuth {
  FutureOr<Response?> handle(Request request);
}
