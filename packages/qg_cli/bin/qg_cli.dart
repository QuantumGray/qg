// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

void main(List<String> args) async {
  final env = Platform.environment;
  int exitCode = 0;

  final runner = CommandRunner('qg', 'qg cli')
    ..addCommand(CreateCommand())
    ..addCommand(SyncCommand())
    ..addCommand(ExportCommand());

  await runner.run(args).catchError((e) {
    if (e is! UsageException) throw e;
    print(e);
    exit(64);
  });
  exit(exitCode);
}

Future<void> writeLines(
    {String? path, List<String>? lines, bool showLineNumbers = false}) async {
  assert(path != null || lines != null);

  var lineNumber = 1;
  final linesStream = path != null
      ? utf8.decoder.bind(File(path).openRead()).transform(const LineSplitter())
      : Stream.fromIterable(lines!);
  try {
    await for (final line in linesStream) {
      if (showLineNumbers) {
        stdout.write('${lineNumber++} ');
      }
      stdout.writeln(line);
    }
  } catch (e) {
    rethrow;
  }
}

class CreateCommand extends Command {
  @override
  String get description => 'creates new Flutter apps';

  @override
  String get name => 'create';

  CreateCommand() {
    argParser.addOption('template', abbr: 't', defaultsTo: null);
    argParser.addOption('name', abbr: 'n', mandatory: true);
  }

  @override
  void run() {
    print("erun");
    final template = argResults?['template'];
    final name = argResults!['name'];
    final res = Process.runSync('cd ./bin', []);

    print(res.stdout);
    final process = Process.runSync('sh bin/scripts/very_good_post.sh', [],
        runInShell: true);

    print(process.stderr);

    // final process =
    //     Process.start('sh scripts/very_good_post.sh', [name], runInShell: true)
    //         .catchError((e) {
    //   print(e);
    // });
  }
}

class SyncCommand extends Command {
  @override
  String get description => 'syncs dependencies';

  @override
  String get name => 'sync';

  SyncCommand() {
    argParser.addOption('config', abbr: 'c');
  }

  @override
  void run() {
    // final config = argResults?['config'];
    // final _pwd = pwd();
    // final configFile = findFile('sync.yaml', _pwd);
    // if (configFile == null) {
    //   exit(2);
    // }
    // final doc = loadYaml(configs.first.readAsStringSync()) as YamlMap;
    // for (final proj in doc.entries) {
    //   final deps = (proj.value as YamlMap).split(' ');

    //   for (final dep in deps) {
    //     Process.run('cd', [dep]);
    //     Process.run('flutter', ['pub', 'get']);
    //     Process.run('cd', ['..']);
    //   }
    // }
  }
}

class ExportCommand extends Command {
  ExportCommand();

  @override
  String get description => 'exports all files inside a directory';

  @override
  String get name => 'export';

  @override
  void run() {
    final _pwd = pwd();
    final lib = findDir('lib', _pwd);
    if (lib == null) {
      exit(2);
    }
    final exportsFile = File(lib.path + '/' + 'exports.dart')..createSync();

    traverse(lib, (file) async {
      if (file.path == exportsFile.path) {
        return;
      }

      final path = relative(file.path, from: lib.path);
      print(path);

      exportsFile.writeAsStringSync('export "$path"; \n',
          mode: FileMode.append, flush: true);
    });

    // final traverser = (Directory dir) {
    //   for (final entitiy in lib.listSync()) {
    //     if (entitiy is File) {
    //       if (entitiy.path == exportsFile.path) {
    //         continue;
    //       }
    //       final dirref =
    //           currentDir == lib ? '' : basename(currentDir.path) + '/';
    //       final fileref = dirref + basename(entitiy.path);
    //       print(fileref);

    //       exportsFile.writeAsString('export "$fileref";', mode: FileMode.write);
    //     }
    //   }
    // };
    // traverser(currentDir);
  }
}

Map<String, String> get env => Platform.environment;

Directory pwd() => Directory.fromUri(Uri.directory(env['PWD']!));

Directory? findDir(String name, Directory inside) {
  final entities = inside.listSync();
  final findings =
      entities.where((e) => (basename(e.path) == name) && e is Directory);
  if (findings.isEmpty) {
    return null;
  }
  return findings.first as Directory;
}

File? findFile(String name, Directory inside) {
  final entities = inside.listSync();
  final findings =
      entities.where((e) => (basename(e.path) == name) && e is File);
  if (findings.isEmpty) {
    return null;
  }
  return findings.first as File;
}

void traverse(Directory dir, void Function(File entity) forEach) {
  final entitiies = dir.listSync();
  for (final entity in entitiies) {
    print(entity.path);
    if (entity is File) {
      forEach(entity);
      continue;
    }
    traverse(entity as Directory, forEach);
  }
}
