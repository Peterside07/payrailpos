import 'package:flutteremv/flutteremv.dart';

var keyboard = Flutteremv();

void startKeyboard(
    {Function(String)? onchange, Function? proceed, Function? cancel}) {
  keyboard.startkeyboard(onchange: onchange, proceed: proceed, cancel: cancel);
  print("keyboard started");
}

void stopKeyboard() {
  keyboard.stopkeyboard();
  print("keyboard stopped");
}
