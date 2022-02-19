import 'dart:io';

import 'package:qg_base/qg_base.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final pWsServer = Provider<WsServer>((ref) => WsServer());

class WsServer {
  late HttpServer server;

  Future<void> serve({required String address, required int port}) async {
    server = await shelf_io.serve(
      webSocketHandler(
        (WebSocketChannel webSocket) {
          webSocket.stream
              .asyncMap((message) async => message)
              .listen((message) {
            webSocket.sink.add("${message.runtimeType}");
          });
        },
      ),
      address,
      port,
    );
  }
}
