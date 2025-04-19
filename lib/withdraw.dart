import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutteremv/flutteremv.dart';
import 'package:flutteremv/transaction_monitor.dart';
import 'package:payrailpos/cardpin.dart';

// import 'package:topwisemp35p/topwisemp35p.dart';

import 'keyboard.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({super.key});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  // final _topwisemp35pPlugin = Topwisemp35p();
  final _topwisemp35pPlugin = Flutteremv();
  var newamountController = TextEditingController();
  var amountController = "";

  void startkeyboarda() {
    startKeyboard(
        onchange: result,
        proceed: proceed,
        cancel: () {
          Navigator.pop(context);
        });
  }

  Future<void> proceed() async {
    _topwisemp35pPlugin.debitcard(amountController);
  }

  void result(String value) {
    if (value != "delete") {
      amountController += value;
    } else {
      if (amountController.isNotEmpty &&
          amountController != "0" &&
          amountController.toString().length > 1) {
        amountController =
            amountController.substring(0, amountController.length - 1);
      } else {
        amountController = "";
      }
    }
    newamountController.text = amountController;
    setState(() {});
  }

  @override
  void initState() {
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
          //   Get.back();
          //  request(value);
          return;
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
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CardPin(),
              )).then((result) {
            if (result != null) {
              print("result $result");
              _topwisemp35pPlugin.enterpin(result);
              startKeyboard();
              // loader(Get.context, "Reading Card");
            }
          });
          return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdrawal'),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            controller: newamountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
              onPressed: () {
                proceed();
              },
              child: Text('Withdraw')),
        ],
      )),
    );
  }
}
