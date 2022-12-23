import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  final stream = await _r();
  print("ctrl returned");
  await for (final s in stream) {
    print("{decode - (${DateTime.now().toIso8601String()}) = <${utf8.decode(s)}>}");
  }
  //ctrl.close();
}

Future<Stream<List<int>>> _r() async {
  var process = await Process.start(
    'python3',
    [
      "/Users/omni/repos/dart_playground/dart_process_stdout/bin/main.py",
    ],
  );
  return process.stdout;

  // https://github.com/dart-lang/sdk/issues/5607#issuecomment-108333788
  // var p = await Process.start('/usr/bin/stdbuf',
  //     ["--output=L", "python3", "/Users/omni/repos/dart_playground/dart_process_stdout/bin/main.py"]);
  // return p.stdout;

  // final ctrl = StreamController<List<int>>();
  // ctrl.sink.addStream();
  // return ctrl;

  // process.stderr.listen((event) {});
  // process.stderr.listen(
  //   (msg) async* {
  //     yield "{decode - (${DateTime.now().toIso8601String()}) = <${utf8.decode(msg)}>";
  //   },
  // );
  // await for (final List<int> msg in process.stdout) {

  // }
}
