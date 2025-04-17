import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payrailpos/cardpin.dart';
import 'package:topwisemp35p/topwisemp35p.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({super.key});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  final _topwisemp35pPlugin = Topwisemp35p();
  var amountController = TextEditingController();

  @override
  void initState() {
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
          
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const CardPin(),
          )).then((result) {
            if(result != null){
              print("result $result");
              _topwisemp35pPlugin.enterpin(result);
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
            controller: amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(onPressed: () {
            _topwisemp35pPlugin.debitcard(amountController.text);
          }, child: Text('Withdraw')),
        ],
      )),
    );
  }
}
