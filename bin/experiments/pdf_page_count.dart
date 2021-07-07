import 'dart:io';

main() async {
  printPageNum("/home/omni/example/example.pdf");
  printPageNum("/home/omni/example/doesNotExist.pdf");
}

void printPageNum(String path) async {
  // Apache v2 instead of GPL like pdfinfo and other poppler tools
  ProcessResult numPageResult = await Process.run("qpdf", ["--show-npages", path]);
  stderr.write(numPageResult.stderr);
  final exitCode = numPageResult.exitCode;

  if (exitCode == 0) {
    int pageNum = int.parse(numPageResult.stdout);
    print(pageNum);
  } else {
    print("Error - $exitCode");
  }
}
