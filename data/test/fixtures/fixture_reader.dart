import 'dart:io';
import 'package:path/path.dart';

final testDirectory = join(
  Directory.current.path,
  Directory.current.path.endsWith('test') ? '' : 'test',
);

String fixture(String fileName) {
  final filePath = '$testDirectory/fixtures/$fileName';
  return File(filePath).readAsStringSync();
}
