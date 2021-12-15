// import 'dart:async';
// import 'dart:isolate';

// import 'package:flutter/widgets.dart';

// Future<Widget> spawnApp(Uri _) async {
//   final port = ReceivePort();

//   final uri = Uri.dataFromString(
//     '''
//     import "dart:isolate";

//     void main(_, SendPort port) {
//       port.send(Text(""));
//     }
//     ''',
//     mimeType: 'application/dart',
//   );

//   final isolate = await Isolate.spawnUri(uri, [], port.sendPort);
//   final Widget response = await (port.first as FutureOr<Widget>);

//   port.close();
//   isolate.kill();

//   print(response.toString());
//   return response;
// }
