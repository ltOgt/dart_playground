import 'package:puppeteer/puppeteer.dart';

void main() async {
  // Download the Chromium binaries, launch it and connect to the "DevTools"
  var browser = await puppeteer.launch();
  print("launcher");

  // Open a new tab
  var myPage = await browser.newPage();
  print("opened page");

  // Go to a page and wait to be fully loaded
  await myPage.goto('https://dart.dev', wait: Until.networkIdle);
  print("navigated");

  // Do something... See other examples
  print(await myPage.evaluate('() => document.title'));
  print("evaluated");

  // Gracefully close the browser's process
  await browser.close();
}
