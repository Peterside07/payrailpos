// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteremv/flutteremv.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/pos_controller.dart';
import 'package:payrailpos/screen/home/withdraw/card_pin.dart';
import 'package:payrailpos/service/storage.dart';
import 'package:payrailpos/widgets/buttons/primary_button.dart';
import 'package:payrailpos/widgets/inputs/app_input.dart';
import 'package:payrailpos/widgets/loaders/app_loader.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  String _platformVersion = 'Unknown';
  final _topwisemp35pPlugin = Flutteremv();
  final posControler = Get.put(POSController());
  final TextEditingController _amountController = TextEditingController();
  bool isLoading = false;
  String amount = "";
  late String base64string;
  Map<String, dynamic> eventresult = {};
  String? cardPin;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _topwisemp35pPlugin.stateStream.listen((values) async {
      print("card state $values");
      switch (values["state"]) {
        case "Loading":
          setState(() => isLoading = true);
          break;
        case "CallBackCanceled":
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction canceled')),
          );
          setState(() => isLoading = false);
          break;
        case "CardReadTimeOut":
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card read timed out')),
          );
          setState(() => isLoading = false);
          break;
        case "CallBackError":
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction canceled')),
          );
          setState(() => isLoading = false);
          break;
        case "CardData":
          setState(() => isLoading = false); // Hide loader before navigation
          eventresult =
              Map<String, dynamic>.from(values["transactionData"] ?? {});
          if (eventresult.isNotEmpty) {
            // Navigate to ProcessingScreen immediately
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProcessingScreen(),
              ),
            );
            // Process the result in the background
            log("Processing result: $eventresult");
            await posControler.processResult(eventresult);

            // Navigation to ReceiptScreen is handled in POSController
          }
          break;
        case "CardDetected":
          setState(() => isLoading = false);
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Carpin(amount: amount)),
          );
          if (result != null) {
            cardPin = result;
            _topwisemp35pPlugin.enterpin(cardPin!);
            setState(
                () => isLoading = true); // Show loading while processing PIN
          }
          break;
      }
    });
    loadLogo();
  }

  String maskPan(String pan) {
    if (pan.length < 10) return pan;
    return '${pan.substring(0, 6)}******${pan.substring(pan.length - 4)}';
  }

  Future<void> loadLogo() async {
    final ByteData assetByteData =
        await rootBundle.load("assets/images/logo.png");
    final Uint8List imagebytes = assetByteData.buffer.asUint8List();
    base64string = base64.encode(imagebytes);
  }

  Future<void> initPlatformState() async {
    final masterKey = await StorageService().getMasterKey();
    final pinKey = await StorageService().getPinKy();

    try {
      print(pinKey);
      print(masterKey);
      var result = await _topwisemp35pPlugin.initialize(
        masterKey,
        pinKey,
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
        message: isLoading && cardPin == null
            ? "Kindly insert card"
            : "Processing PIN...",
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
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  var result = await _topwisemp35pPlugin.getcardsheme("200");
                  print("Card scheme result: $result");
                },
                child: const Text("Get Card Scheme"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProcessingScreen extends StatelessWidget {
  const ProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Processing transaction...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
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
//     final posControler = Get.put(POSController());

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
//         case "CallBackCanceled":
//         Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Transaction canceled')),
//           );
//         return; 
//         case "CardReadTimeOut":
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Card read timed out')),
//           );
//           return;
//         case "CallBackError":
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Transaction canceled')),
//           );
//           return;
//         case "CardData":
//           eventresult =
//               Map<String, dynamic>.from(values["transactionData"] ?? {});
//               if(eventresult.isNotEmpty){
//                 posControler.processResult(eventresult);
//               }
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
//       }
//     });
//     loadLogo();
//   }

//   String maskPan(String pan) {
//     if (pan.length < 10) return pan;
//     return '${pan.substring(0, 6)}******${pan.substring(pan.length - 4)}';
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

