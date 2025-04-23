import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteremv/flutteremv.dart';
import 'package:flutteremv/transaction_monitor.dart';
import 'package:get/get.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/home/withdraw/select_account.dart';
import 'package:payrailpos/widgets/buttons/primary_button.dart';
import 'package:payrailpos/widgets/inputs/app_input.dart';
import 'package:payrailpos/widgets/utils.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final TextEditingController _amountController = TextEditingController();
    final _topwisemp35pPlugin = Flutteremv();

  final FocusNode _focusNode = FocusNode();

  // @override
  // void initState() {
  //   super.initState();
  //   // Request focus to capture keyboard events
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _focusNode.requestFocus();
  //   });
  // }

   void startkeyboarda() {
    // startKeyboard(
    //     onchange: result,
    //     proceed: proceed,
    //     cancel: () {
    //       Navigator.pop(context);
    //     });
  }

    @override
  void initState() {
     _focusNode.requestFocus();
    startkeyboarda();
    _topwisemp35pPlugin.stateStream.listen((values) async {
      print(" card state $values");
      // if(statereceived) return;
      // statereceived = true;
      // setState((){});
      print("another card state $values");
      // Handle the state change here
      var value = transactionMonitorFromJson(jsonEncode(values));
      switch (value.state) {
        case "Loading":
          //  Insertcardloader(Get.context);
          return;
        case "CardData":
          print(values);
          print("card data state after reading data $values");
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => Receipt(
          //         value.transactionData!,
          //       ),
          //     )).then((result) {
          //   // if (result != null) {
          //   //   print("result $result");
          //   //   _topwisemp35pPlugin.enterpin(result);
          //   //   startKeyboard();
          //   // }
          // });
          // return;
          // var args = Print(
          //           base64image: "base64string",
          //           marchantname: "VERDANT MICROFINANCE BANK",
          //           datetime: "27 Jan 2023,06:55AM",
          //           terminalid: "2LUX4199",
          //           merchantid: "2LUXAA00000001",
          //           transactiontype: "CARD WITHDRAWAL",
          //           copytype: "Merchant",
          //           rrn: "561409897476",
          //           stan: "904165",
          //           pan: "539983******1954",
          //           expiry: "2303",
          //           transactionstatus: "DECLINED",
          //           responsecode: "55",
          //           message: "Incorrect PIN",
          //           appversion: "1.5.3",
          //           amount: "200",
          //           bottommessage:
          //               "Buy Airtime and Pay Electricity bills here anytime!    AnyDAY!",
          //           marchantaddress: '',
          //           serialno: '',
          //         );
          // _topwisemp35pPlugin.startprinting(args);
          //   Get.back();
          //  request(value);
        case "CardReadTimeOut":
        case "CallBackError":
        case "CallBackTransResult":
          //user cancel transaction
          //   errorloader(Get.context,
          //     value.message,
          //         (){
          //       Get.back();
          //     }
          // );
          return;
        // case "CallBackCanceled":
        case "CardDetected":
          print("card detected state $values");
          //   Get.back();
          //  f();
          // var result = await Get.toNamed(Routes.CARDPIN, arguments: {"amount": amountController, "pan": value.message});
          // if(result != null){
          //   _topwisemp35pPlugin.enterpin(result);
          //   loader(Get.context, "Reading Card");
          // }

          stopKeyboard();
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const CardPin(),
          //     )).then((result) {
          //   if (result != null) {
          //     print("result $result");
          //     _topwisemp35pPlugin.enterpin(result);
          //     startKeyboard();

          //     // loader(Get.context, "Reading Card");
          //   }
     //     });
          return;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Handle terminal keyboard input
  // void _handleKeyEvent(KeyEvent event) {
  //   if (event is KeyDownEvent) {
  //     // Handle Enter key (green "O" on terminal) to confirm withdrawal
  //     if (event.logicalKey == LogicalKeyboardKey.enter) {
  //       _submitWithdrawal();
  //     }
  //     // Handle Escape or "X" key (red "X" on terminal) to dismiss
  //     else if (event.logicalKey == LogicalKeyboardKey.escape) {
  //       Get.back();
  //     }
  //     // Handle numeric input (0-9)
  //     else if (event.logicalKey.keyLabel != null &&
  //         RegExp(r'[0-9]').hasMatch(event.logicalKey.keyLabel)) {
  //       setState(() {
  //         _amountController.text += event.logicalKey.keyLabel;
  //       });
  //     }
  //     // Handle backspace (yellow "<" on terminal)
  //     else if (event.logicalKey == LogicalKeyboardKey.backspace) {
  //       setState(() {
  //         if (_amountController.text.isNotEmpty) {
  //           _amountController.text = _amountController.text
  //               .substring(0, _amountController.text.length - 1);
  //         }
  //       });
  //     }
  //   }
  // }

  void _submitWithdrawal() {
    if (_amountController.text.isEmpty) {
      AppAlert(
        title: 'Error',
        message: 'Please enter an amount to withdraw',
      ).showAlert();
      return;
    }
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      AppAlert(
        title: 'Error',
        message: 'Please enter a valid amount',
      ).showAlert();
      return;
    }
    // Proceed with withdrawal logic (e.g., API call)
    // Get.snackbar('Success', 'withdrawal_submitted'.tr);
    // Get.back();
    print('Withdrawal submitted: $amount');
    Get.to(() => SelectAccount(
          amount: amount,
        ));
    // Add your withdrawal logic here
    // For example, you can call an API to process the withdrawal
    // and then show a success message or navigate to another screen.
  }

    Future<void> proceed() async {
    _topwisemp35pPlugin.debitcard(_amountController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        //  onKeyEvent: _handleKeyEvent,
        autofocus: true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter amount to withdraw',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: AppInput(
                  isTextArea: false,
                  prefixIcon: const Icon(
                    Icons.monetization_on,
                    color: Colors.black,
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.none,
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Proceed',
                onPressed: () {
                  _submitWithdrawal();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}



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