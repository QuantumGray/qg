import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qg_base/client.dart';
import 'package:qg_flutter_base/base/base.dart' hide Text;
import 'package:qg_flutter_base/presentation/presentation.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Page pageBuilder(BuildContext context, GoRouterState state) =>
      const MaterialPage(
        child: HomeScreen(),
      );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late HttpClient http;

  @override
  void initState() {
    super.initState();

    http = HttpClient(
      baseUrl: 'http://localhost:8080',
    );
  }

  void _ping() async {
    try {
      final response = await http.client.get('/hfsahfasfha');
      print(response);
    } on Exception catch (e) {
      print(e);
    }
  }

  void _uploadFile() async {
    final file = File('idk')
      ..writeAsBytesSync(
        (await rootBundle.load('assets/logos/coup.png')).buffer.asUint8List(),
      );
    final files = await http.uploadFiles([
      file,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final listViewTiles = [
      ElevatedButton(
        onPressed: _ping,
        child: Text(
          'ping server',
        ),
      ),
      ElevatedButton(
        onPressed: _uploadFile,
        child: Text(
          'upload file',
        ),
      )
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Home',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                itemBuilder: (context, index) => listViewTiles[index],
                separatorBuilder: (context, index) => const Divider(),
                itemCount: listViewTiles.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
