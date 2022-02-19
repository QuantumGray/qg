import 'dart:convert';

import 'package:googleapis/firestore/v1.dart';
import 'package:qg_base/qg_base.dart' hide Response, Request;
import 'package:qg_server_starter/env.dart';
import 'package:shelf_plus/shelf_plus.dart';

class Firestore {
  final Reader read;
  Firestore(this.read);

  FirestoreApi? __firestore;

  ProjectsResource get _firestore =>
      (__firestore ??= FirestoreApi(read(pGapiAuthClient))).projects;

  String get projectId => read(pEnv).gcpProjectId;

  Future<Response> incrementHandler(Request request) async {
    final result = await _firestore.databases.documents.commit(
      _incrementRequest(projectId),
      'projects/$projectId/databases/(default)',
    );

    return Response.ok(
      JsonUtf8Encoder(' ').convert(result),
      headers: {
        'content-type': 'application/json',
      },
    );
  }
}

CommitRequest _incrementRequest(String projectId) => CommitRequest(
      writes: [
        Write(
          transform: DocumentTransform(
            document:
                'projects/$projectId/databases/(default)/documents/settings/count',
            fieldTransforms: [
              FieldTransform(
                fieldPath: 'count',
                increment: Value(integerValue: '1'),
              )
            ],
          ),
        ),
      ],
    );
