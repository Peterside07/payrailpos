// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutteremv/flutteremv.dart';
// import 'package:flutteremv/print.dart';
// import 'package:flutteremv/transaction_monitor.dart';
// import 'package:payrailpos/cardpin.dart';
// // import 'package:payrailpos/receipt.dart';

// // import 'package:topwisemp35p/topwisemp35p.dart';

// import 'keyboard.dart';

// class Withdrawal extends StatefulWidget {
//   const Withdrawal({super.key});

//   @override
//   State<Withdrawal> createState() => _WithdrawalState();
// }

// class _WithdrawalState extends State<Withdrawal> {
//   // final _topwisemp35pPlugin = Topwisemp35p();
//   final _topwisemp35pPlugin = Flutteremv();
//   var newamountController = TextEditingController();
//   var amountController = "";

//   void startkeyboarda() {
//     // startKeyboard(
//     //     onchange: result,
//     //     proceed: proceed,
//     //     cancel: () {
//     //       Navigator.pop(context);
//     //     });
//   }

//   Future<void> proceed() async {
//     _topwisemp35pPlugin.debitcard(amountController);
//   }

//   void result(String value) {
//     if (value != "delete") {
//       amountController += value;
//     } else {
//       if (amountController.isNotEmpty &&
//           amountController != "0" &&
//           amountController.toString().length > 1) {
//         amountController =
//             amountController.substring(0, amountController.length - 1);
//       } else {
//         amountController = "";
//       }
//     }
//     newamountController.text = amountController;
//     setState(() {});
//   }

//   @override
//   void initState() {
//     startkeyboarda();
//     _topwisemp35pPlugin.stateStream.listen((values) async {
//       log(" card state $values");
//       // if(statereceived) return;
//       // statereceived = true;
//       // setState((){});
//       log("another card state $values");
//       // Handle the state change here
//       var value = transactionMonitorFromJson(jsonEncode(values));
//       switch (value.state) {
//         case "Loading":
//           //  Insertcardloader(Get.context);
//           return;
//         case "CardData":
//           log(values);
//           // Navigator.push(
//           //     context,
//           //     MaterialPageRoute(
//           //       builder: (context) => Receipt(
//           //         value.transactionData!,
//           //       ),
//           //     )).then((result) {
//           //   // if (result != null) {
//           //   //   print("result $result");
//           //   //   _topwisemp35pPlugin.enterpin(result);
//           //   //   startKeyboard();
//           //   // }
//           // });
//           return;
//           // var args = Print(
//           //           base64image: "base64string",
//           //           marchantname: "VERDANT MICROFINANCE BANK",
//           //           datetime: "27 Jan 2023,06:55AM",
//           //           terminalid: "2LUX4199",
//           //           merchantid: "2LUXAA00000001",
//           //           transactiontype: "CARD WITHDRAWAL",
//           //           copytype: "Merchant",
//           //           rrn: "561409897476",
//           //           stan: "904165",
//           //           pan: "539983******1954",
//           //           expiry: "2303",
//           //           transactionstatus: "DECLINED",
//           //           responsecode: "55",
//           //           message: "Incorrect PIN",
//           //           appversion: "1.5.3",
//           //           amount: "200",
//           //           bottommessage:
//           //               "Buy Airtime and Pay Electricity bills here anytime!    AnyDAY!",
//           //           marchantaddress: '',
//           //           serialno: '',
//           //         );
//           // _topwisemp35pPlugin.startprinting(args);
//           //   Get.back();
//           //  request(value);
//         case "CardReadTimeOut":
//         case "CallBackError":
//         case "CallBackTransResult":
//           //user cancel transaction
//           //   errorloader(Get.context,
//           //     value.message,
//           //         (){
//           //       Get.back();
//           //     }
//           // );
//           return;
//         // case "CallBackCanceled":
//         case "CardDetected":
//           log("card detected state $values");
//           //   Get.back();
//           //  f();
//           // var result = await Get.toNamed(Routes.CARDPIN, arguments: {"amount": amountController, "pan": value.message});
//           // if(result != null){
//           //   _topwisemp35pPlugin.enterpin(result);
//           //   loader(Get.context, "Reading Card");
//           // }

//        //   stopKeyboard();
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const CardPin(),
//               )).then((result) {
//             if (result != null) {
//               log("result $result");
//               _topwisemp35pPlugin.enterpin(result);
//            //   startKeyboard();

//               // loader(Get.context, "Reading Card");
//             }
//           });
//           return;
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Withdrawal'),
//       ),
//       body: Center(
//           child: Column(
//         children: [
//           TextField(
//             controller: newamountController,
//             decoration: InputDecoration(
//               labelText: 'Amount',
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 proceed();
//               },
//               child: Text('Withdraw')),
//         ],
//       )),
//     );
//   }
// }
