import 'package:flutteremv/flutteremv.dart';
// import 'package:topwisemp35p/topwisemp35p.dart';

// var keyboard = Topwisemp35p();
var keyboard = Flutteremv();
// KeyboardControl(
//     {
//       // required this.amountController,
//       this.onchange,
//       this.cancel,
//       this.proceed});
void startKeyboard(
    {Function(String)? onchange, Function? proceed, Function? cancel}) {
  keyboard.startkeyboard(onchange: onchange, proceed: proceed, cancel: cancel);
  print("keyboard started");
}

void stopKeyboard() {
  keyboard.stopkeyboard();
  print("keyboard stopped");
}
