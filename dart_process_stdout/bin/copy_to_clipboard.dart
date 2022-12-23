import 'dart:io';

void main(List<String> args) async {
  final name = true ? "image.png" : "img/image.png";
  final p =
      await Process.run("osascript", ["-e", 'set the clipboard to (read (POSIX file "image.png") as PNG picture)']);
  print("done");
}
