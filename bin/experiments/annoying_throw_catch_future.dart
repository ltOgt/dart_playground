import 'dart:io';

Future<void> nonAsynchError() {
  return Future.delayed(Duration(seconds: 1)).then((value) => throw "e");
}

Future<void> asynchError() async {
  await Future.delayed(Duration(seconds: 1));
  throw "e";
}

Future<void> del() async {
  await Directory("DOES_NOT_EXIST").delete();
}

void main() async {
  try {
    await asynchError();
  } catch (e) {
    print(e);
  }

  try {
    await nonAsynchError().onError((error, stackTrace) => throw error ?? "");
  } catch (e) {
    print(e);
  }

  try {
    await nonAsynchError();
  } catch (e) {
    print(e);
  }

  try {
    await del();
  } catch (e) {
    print(e);
  }
}
