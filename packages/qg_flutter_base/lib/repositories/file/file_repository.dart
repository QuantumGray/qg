import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qg_dart_base/qg_dart_base.dart' hide ZipFile, Response;
import 'package:qg_flutter_base/repositories/base_repository.dart';
import 'package:qg_flutter_base/base/utils/utils.dart';

final Provider<FileRepository> pFileRepository =
    Provider<FileRepository>((ref) => FileRepository(ref.read));

class FileRepository extends BaseRepository {
  FileRepository(Reader read) : super(read);

  Future<String> _docDirPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  Future<File> writeToFile({
    required String data,
    required String to,
  }) async {
    return File('${await _docDirPath()}$to').writeAsString(data);
  }

  Future<String> readFromFile({
    required String from,
  }) async {
    try {
      return File('${await _docDirPath()}$from').readAsString();
    } catch (e) {
      return "";
    }
  }

  Future<File> moveFile({
    required String from,
    required String to,
    bool differentFileSystem = false,
  }) async {
    if (differentFileSystem) {
      final File _destinationFile = File(to);
      final File _sourceFile = File(from);
      _destinationFile.writeAsString(await _sourceFile.readAsString());
      _sourceFile.delete();
      return _destinationFile;
    }
    return File(from).rename(to);
  }

  // Stream<void> extractZip({
  //   required String zipFilePath,
  //   required String to,
  //   ZipFileOperation Function(ZipEntry zipEntry, double progress)? onExtracting,
  // }) async* {
  //   try {
  //     await ZipFile.extractToDirectory(
  //       zipFile: File(zipFilePath),
  //       destinationDir: Directory(to),
  //       onExtracting: (zipEntry, progress) {
  //         if (onExtracting != null) {
  //           return onExtracting(zipEntry, progress);
  //         }
  //         throw UnimplementedError();
  //       },
  //     );
  //   } catch (e) {
  //     l.e(e);
  //   }
  // }

  // Future<Stream<ProgressState>> fetchAssetBundle() async {
  //   final StreamController<ProgressState> _streamController =
  //       StreamController<ProgressState>.broadcast();
  //   _streamController.onListen =
  //       () => _assetBundleProcess(_streamController.sink);
  //   return _streamController.stream;
  // }

  // Future<void> _assetBundleProcess(EventSink<ProgressState> _sink) async {
  //   final String _tempDirPath =
  //       '${(await getTemporaryDirectory()).path}/material_product_sounds.zip';
  //   try {
  //     final _zipFile = File(_tempDirPath);

  //     await _zipFile.delete();
  //     await getApplicationDocumentsDirectory().then(
  //       (dir) => Directory('${dir.path}/material_product_sounds')..delete(),
  //     );
  //     if (!(await _zipFile.exists())) {
  //       final Response _ = await Dio().download(
  //         'https://storage.googleapis.com/material_product_sounds_bucket/material_product_sounds.zip',
  //         _tempDirPath,
  //         onReceiveProgress: (received, total) {
  //           if (total != -1) {
  //             _sink.add(ProgressState("download", received / total * 100));
  //           }
  //         },
  //       );
  //       final _zipFile = File(_tempDirPath);
  //       await ZipFile.extractToDirectory(
  //         zipFile: _zipFile,
  //         destinationDir: await getApplicationDocumentsDirectory(),
  //         onExtracting: (_, d) {
  //           _sink.add(ProgressState("extract", d));
  //           return ZipFileOperation.includeItem;
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     l.i(e);
  //   }
  // }
}

class ProgressState {
  const ProgressState(this.state, this.progress);
  final String state;
  final double progress;
}
