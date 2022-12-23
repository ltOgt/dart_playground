import 'dart:convert';
import 'dart:io';
import 'package:webdriver/io.dart';

main() async {
  // Start the ChromeDriver process
  Process chromeDriverProcess = await Process.start('geckodriver', ["--websocket-port=60530", "--port=60529"]);

  // might need to kill
  // $ ps ax | grep geckodriver
  // $ kill <pid>
  await for (String browserOut in const LineSplitter().bind(utf8.decoder.bind(chromeDriverProcess.stdout))) {
    // §|$ 1667068795778	geckodriver	INFO	Listening on 127.0.0.1:4444
    if (browserOut.contains('geckodriver') && browserOut.contains('Listening on')) {
      break;
    }
  }

  // Connect to it with the webdriver package
  WebDriver driver = await createDriver(uri: Uri.parse('http://localhost:61200'), desired: Capabilities.firefox);

  // Go to your page
  await driver.get('http://stackoverflow.com');

  //TODO: write your tests
  print(await driver.execute('return navigator.userAgent', []));

  // Take a simple screenshot
  // String screenshot = await driver.captureScreenshotAsBase64();
  // new File('stackoverflow.png').writeAsBytesSync(BASE64.decode(screenshot));

  driver.quit();
  chromeDriverProcess.kill();
}
