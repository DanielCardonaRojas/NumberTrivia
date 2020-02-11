import 'dart:io';
import "package:path/path.dart" show dirname;
import 'dart:io' show Platform;

main() {
  print(dirname(Platform.script.toString()));
}

String fixture(String fileName) {
  return File('../data/test/fixtures/$fileName').readAsStringSync();
}
