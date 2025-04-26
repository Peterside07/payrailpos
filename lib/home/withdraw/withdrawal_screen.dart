import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteremv/flutteremv.dart';
import 'package:flutteremv/print.dart';
import 'package:payrailpos/home/withdraw/card_pin.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/buttons/primary_button.dart';
import 'package:payrailpos/widgets/inputs/app_input.dart';
import 'package:payrailpos/widgets/loaders/app_loader.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutteremv/flutteremv.dart';
import 'package:http/http.dart' as http;

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  String _platformVersion = 'Unknown';
  final _topwisemp35pPlugin = Flutteremv();
  final TextEditingController _amountController = TextEditingController();
  bool isLoading = false;

  String amount = "";
  late String base64string;
  Map<String, dynamic> eventresult = {};

  

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  //   _topwisemp35pPlugin.stateStream.listen((values) async {
  //     print("card state $values");
  //     switch (values["state"]) {
  //       case "Loading":
  //         return;
  //       case "CardData":
  //         print("Card detected, waiting for card data...");
  //         print("Card data: $values");

  //         return;
  //       case "CardDetected":
  //         print("Got card data");
  //         setState(() => isLoading = false);
  //         eventresult =
  //             Map<String, dynamic>.from(values["transactionData"] ?? {});

  //         final result = await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => Carpin(
  //               amount: amount,
  //               cardData: eventresult,
  //               base64string: base64string,
  //             ),
  //           ),
  //         );

  //         if (result != null && result.isNotEmpty) {
  //           _topwisemp35pPlugin.enterpin(result);
  //         }
  //         return;
  //     }
  //   });
  //   loadLogo();
  // }

  Future<void> loadLogo() async {
    final ByteData assetByteData =
        await rootBundle.load("assets/images/logo.png");
    final Uint8List imagebytes = assetByteData.buffer.asUint8List();
    base64string = base64.encode(imagebytes);
  }

  Future<void> initPlatformState() async {
    try {
      var result = await _topwisemp35pPlugin.initialize(
        "3F2216D8297BCE9C",
        "0000000002DDDDE00001",
      );
      print(result);
      _platformVersion = await _topwisemp35pPlugin.deviceserialnumber() ??
          'Unknown platform version';
    } on PlatformException {
      _platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {});
  }

  void _handleProceed() {
    amount = _amountController.text.trim();

    if (amount.isEmpty ||
        double.tryParse(amount) == null ||
        double.parse(amount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid amount."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    _topwisemp35pPlugin.debitcard(amount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLoader(
        isLoading: isLoading,
        message: "Kindly insert your card",
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                onPressed: _handleProceed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Carpin extends StatefulWidget {
  final String amount;
  final Map<String, dynamic> cardData;
  final String base64string;

  const Carpin(
      {Key? key,
      required this.amount,
      required this.cardData,
      required this.base64string})
      : super(key: key);

  @override
  _CarpinState createState() => _CarpinState();
}

class _CarpinState extends State<Carpin> {
  String pin = "";
  final _topwisemp35pPlugin = Flutteremv();

  @override
  void initState() {
    super.initState();
    _topwisemp35pPlugin.startkeyboard(
      onchange: result,
      proceed: proceed,
      cancel: cancel,
    );
  }

  void result(String value) {
    if (value != "delete") {
      if (pin.length < 4) pin += value;
    } else {
      if (pin.isNotEmpty) pin = pin.substring(0, pin.length - 1);
    }
    setState(() {});
  }

  void proceed() {
    _topwisemp35pPlugin.stopkeyboard();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          amount: widget.amount,
          pin: pin,
          cardData: widget.cardData,
          base64string: widget.base64string,
        ),
      ),
    );
  }

  void cancel() {
    _topwisemp35pPlugin.cancelcardprocess();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _topwisemp35pPlugin.stopkeyboard();
    super.dispose();
  }

  Widget buildPinBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 50,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: pin.length > index
                ? AppColors.PRIMARY_COLOR
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12, width: 1.5),
          ),
          child: Text(
            pin.length > index ? "●" : "",
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text("₦${widget.amount}",
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Enter Card PIN", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 30),
          buildPinBoxes(),
        ],
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final String amount;
  final String pin;
  final Map<String, dynamic> cardData;
  final String base64string;

  const ResultScreen(
      {super.key,
      required this.amount,
      required this.pin,
      required this.cardData,
      required this.base64string});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isLoading = true;
  bool isSuccess = false;
  String message = "Processing...";

  @override
  void initState() {
    super.initState();
    _sendToBackend();
  }

  Future<void> _sendToBackend() async {
    //try {
    // final response = await http.post(
    //   Uri.parse("https://yourapi.com/card/transaction"),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode({
    //     "amount": widget.amount,
    //     "pin": widget.pin,
    //     "cardData": widget.cardData,
    //   }),
    // );

    // if (response.statusCode == 200) {
    //   setState(() {
    isSuccess = true;
    message = "Transaction Successful";
    //  });
    // } else {
    //   setState(() {
    //     message = "Transaction Failed: ${response.body}";
    //   });
    // }
    // } catch (e) {
    //   setState(() {
    //     message = "Error: $e";
    //   });
    //} finally {
    setState(() => isLoading = false);
    //  }
  }

  void _printReceipt() {
    final maskedPan = widget.cardData["applicationPrimaryAccountNumber"];
    final args = Print(
      base64image: widget.base64string,
      marchantname: "PAYRAIL AGENCY ",
      datetime: DateTime.now().toString(),
      terminalid: "2LUX4199",
      merchantid: "2LUXAA00000001",
      transactiontype: "CARD WITHDRAWAL",
      copytype: "Merchant",
      rrn: "561409897476",
      stan: "904165",
      pan: maskedPan ?? "************",
      expiry: widget.cardData["expirationDate"] ?? "--",
      transactionstatus: isSuccess ? "APPROVED" : "DECLINED",
      responsecode: isSuccess ? "00" : "55",
      message: message,
      appversion: "1.5.3",
      amount: widget.amount,
      bottommessage: "Thanks for using our service!",
      marchantaddress: '',
      serialno: '',
    );
    Flutteremv().startprinting(args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Result")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Amount: ₦${widget.amount}",
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text("Status: ${isSuccess ? "Success" : "Failure"}",
                        style: TextStyle(
                            fontSize: 18,
                            color: isSuccess ? Colors.green : Colors.red)),
                    const SizedBox(height: 12),
                    Text("Message: $message", textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _printReceipt,
                      child: const Text("Print Receipt"),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

// class WithdrawalScreen extends StatefulWidget {
//   const WithdrawalScreen({Key? key}) : super(key: key);

//   @override
//   _WithdrawalScreenState createState() => _WithdrawalScreenState();
// }

// class _WithdrawalScreenState extends State<WithdrawalScreen> {
//   String _platformVersion = 'Unknown';
//   final _topwisemp35pPlugin = Flutteremv();
//   final TextEditingController _amountController = TextEditingController();
//   bool isLoading = false;

//   String amount = "";
//   late String base64string;
//   Map<String, dynamic> eventresult = {};
//   String? cardPin;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     _topwisemp35pPlugin.stateStream.listen((values) async {
//       print("card state $values");
//       switch (values["state"]) {
//         case "Loading":
//           return;
//         case "CardData":
//           eventresult =
//               Map<String, dynamic>.from(values["transactionData"] ?? {});
//           return;
//         case "CardDetected":
//           setState(() => isLoading = false);
//           var result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Carpin(amount: amount)),
//           );
//           if (result != null) {
//             cardPin = result;
//             _topwisemp35pPlugin.enterpin(cardPin!);
//           }
//           return;
//         case "CallBackTransResult":
//           setState(() => isLoading = false);
//           final isSuccess = values["message"] == "Transaction Successful";

//           await showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//               title: Text(
//                   isSuccess ? "Transaction Approved" : "Transaction Failed"),
//               content: Text(isSuccess
//                   ? "Your withdrawal was successful."
//                   : "The transaction was declined or failed. Please try again."),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     if (isSuccess) {
//                       final args = Print(
//                         base64image: base64string,
//                         marchantname: "VERDANT MICROFINANCE BANK",
//                         datetime: DateTime.now().toString(),
//                         terminalid: "2LUX4199",
//                         merchantid: "2LUXAA00000001",
//                         transactiontype: "CARD WITHDRAWAL",
//                         copytype: "Merchant",
//                         rrn: "561409897476",
//                         stan: "904165",
//                         pan: maskPan(
//                             eventresult["applicationPrimaryAccountNumber"] ??
//                                 "************"),
//                         expiry: eventresult["expirationDate"] ?? "--",
//                         transactionstatus: isSuccess ? "APPROVED" : "DECLINED",
//                         responsecode: isSuccess ? "00" : "55",
//                         message:
//                             isSuccess ? "Transaction Successful" : "Declined",
//                         appversion: "1.5.3",
//                         amount: amount,
//                         bottommessage:
//                             "Buy Airtime and Pay Electricity bills here anytime! AnyDAY!",
//                         marchantaddress: '',
//                         serialno: '',
//                       );
//                       _topwisemp35pPlugin.startprinting(args);
//                     }
//                   },
//                   child: const Text("Print Receipt"),
//                 )
//               ],
//             ),
//           );
//           return;
//       }
//     });
//     loadLogo();
//   }

//   String maskPan(String pan) {
//     if (pan.length < 10) return pan;
//     return pan.substring(0, 6) + '******' + pan.substring(pan.length - 4);
//   }

//   Future<void> loadLogo() async {
//     final ByteData assetByteData =
//         await rootBundle.load("assets/images/logo.png");
//     final Uint8List imagebytes = assetByteData.buffer.asUint8List();
//     base64string = base64.encode(imagebytes);
//   }

//   Future<void> initPlatformState() async {
//     try {
//       var result = await _topwisemp35pPlugin.initialize(
//         "3F2216D8297BCE9C",
//         "0000000002DDDDE00001",
//       );
//       print(result);
//       _platformVersion = await _topwisemp35pPlugin.deviceserialnumber() ??
//           'Unknown platform version';
//     } on PlatformException {
//       _platformVersion = 'Failed to get platform version.';
//     }

//     if (!mounted) return;
//     setState(() {});
//   }

//   void _handleProceed() {
//     amount = _amountController.text.trim();

//     if (amount.isEmpty ||
//         double.tryParse(amount) == null ||
//         double.parse(amount) <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please enter a valid amount."),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     _topwisemp35pPlugin.debitcard(amount);
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AppLoader(
//         isLoading: isLoading,
//         message: "Kindly insert your card",
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Text(
//                 'Enter amount to withdraw',
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 height: 100,
//                 child: AppInput(
//                   isTextArea: false,
//                   prefixIcon: const Icon(
//                     Icons.monetization_on,
//                     color: Colors.black,
//                   ),
//                   controller: _amountController,
//                   keyboardType: TextInputType.none,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               PrimaryButton(
//                 label: 'Proceed',
//                 onPressed: _handleProceed,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () async {
//                   var result = await _topwisemp35pPlugin.getcardsheme("200");
//                   print("Card scheme result:");
//                   print(result);
//                 },
//                 child: const Text("Get Card Scheme"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class WithdrawalScreen extends StatefulWidget {
//   const WithdrawalScreen({Key? key}) : super(key: key);

//   @override
//   _WithdrawalScreenState createState() => _WithdrawalScreenState();
// }

// class _WithdrawalScreenState extends State<WithdrawalScreen> {
//   String _platformVersion = 'Unknown';
//   final _topwisemp35pPlugin = Flutteremv();
//   final TextEditingController _amountController = TextEditingController();
//   bool isLoading = false;

//   var eventresult = {};
//   String amount = "";
//   late String base64string;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     _topwisemp35pPlugin.stateStream.listen((values) async {
//       print("card state $values");
//       switch (values["state"]) {
//         case "Loading":
//           // Already handled via button
//           return;
//         case "CardData":
//           eventresult = values;
//           return;
//         case "CardReadTimeOut":
//         case "CallBackError":
//         case "CallBackCanceled":
//         case "CallBackTransResult":
//           return;
//         case "CardDetected":
//           setState(() {
//             isLoading = false;
//           });
//           Navigator.pop(context);
//           var result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Carpin(amount: amount)),
//           );
//           if (result != null) {
//             _topwisemp35pPlugin.enterpin(result);
//           }
//           return;
//       }
//     });
//     loadLogo();
//   }

//   Future<void> loadLogo() async {
//     final ByteData assetByteData =
//         await rootBundle.load("assets/images/logo.png");
//     final Uint8List imagebytes = assetByteData.buffer.asUint8List();
//     base64string = base64.encode(imagebytes);
//   }

//   Future<void> initPlatformState() async {
//     try {
//       var result = await _topwisemp35pPlugin.initialize(
//         "3F2216D8297BCE9C",
//         "0000000002DDDDE00001",
//       );
//       print(result);
//       _platformVersion = await _topwisemp35pPlugin.deviceserialnumber() ??
//           'Unknown platform version';
//     } on PlatformException {
//       _platformVersion = 'Failed to get platform version.';
//     }

//     if (!mounted) return;
//     setState(() {});
//   }

//   void _handleProceed() {
//     amount = _amountController.text.trim();

//     if (amount.isEmpty ||
//         double.tryParse(amount) == null ||
//         double.parse(amount) <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please enter a valid amount."),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     _topwisemp35pPlugin.debitcard(amount);
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AppLoader(
//         isLoading: isLoading,
//         message: "Kindly insert your card",
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Text(
//                 'Enter amount to withdraw',
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 height: 100,
//                 child: AppInput(
//                   isTextArea: false,
//                   prefixIcon: const Icon(
//                     Icons.monetization_on,
//                     color: Colors.black,
//                   ),
//                   controller: _amountController,
//                   keyboardType: TextInputType.none,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               PrimaryButton(
//                 label: 'Proceed',
//                 onPressed: _handleProceed,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () async {
//                   var result = await _topwisemp35pPlugin.getcardsheme("200");
//                   print("Card scheme result:");
//                   print(result);
//                 },
//                 child: const Text("Get Card Scheme"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   var args = Print(
//                     base64image: base64string,
//                     marchantname: "VERDANT MICROFINANCE BANK",
//                     datetime: "27 Jan 2023,06:55AM",
//                     terminalid: "2LUX4199",
//                     merchantid: "2LUXAA00000001",
//                     transactiontype: "CARD WITHDRAWAL",
//                     copytype: "Merchant",
//                     rrn: "561409897476",
//                     stan: "904165",
//                     pan: "539983******1954",
//                     expiry: "2303",
//                     transactionstatus: "DECLINED",
//                     responsecode: "55",
//                     message: "Incorrect PIN",
//                     appversion: "1.5.3",
//                     amount: amount,
//                     bottommessage:
//                         "Buy Airtime and Pay Electricity bills here anytime! AnyDAY!",
//                     marchantaddress: '',
//                     serialno: '',
//                   );
//                   _topwisemp35pPlugin.startprinting(args).then(print);
//                 },
//                 child: const Text("Print Withdrawal"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
