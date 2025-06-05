//   // Rest of the processResult function remains unchanged
//   Future processResult(Map<String, dynamic> transactionData) async {
//     final now = DateTime.now(); // 10:16 AM WAT, May 29, 2025
//     final field7 = DateFormat('MMddHHmmss').format(now); // 0529101600
//     final field11 = generateStan(); // e.g., 123456
//     final field12 = DateFormat('HHmmss').format(now); // 101600
//     final field13 = DateFormat('MMdd').format(now); // 0529

//     // Merchant type config (replace with PayU/terminal values)
//     const merchantId = '5045';
//      //Merchant Category Code (MCC)
//     const merchantMcc = '0000'; // Merchant Category Code (MCC)
//     const acquirerId = '2011LA018411459';
//     //marchant type(from their endpon)
//     var merchanttype = '0000'; // Default MCC for PayU


//     // Construct message for field128
//     final messageForMac = '0200${transactionData['applicationPrimaryAccountNumber'] ?? ''}'
//         '${transactionData['amountAuthorized'] ?? ''}$field7$field11';
//     const workingKey = '3b8abc0bfbe0e5b97fab408f1f985b64';
//     final field128 = generateMac(messageForMac, workingKey);



// String generateMacc(Map<String, dynamic> message) {
//   // Remove field128 if it exists — it shouldn't be part of the hash
//   Map<String, dynamic> filteredMessage = Map.of(message)..remove('field128');

//   // Sort keys (assuming order matters)
//   var sortedKeys = filteredMessage.keys.toList()..sort();

//   // Build the message string (concatenate all values in field order)
//   StringBuffer buffer = StringBuffer();
//   for (var key in sortedKeys) {
//     var value = filteredMessage[key];
//     if (value != null && value is String) {
//       buffer.write(value);
//     }
//   }
//   print('Buffer: ${buffer.toString()}');



//   // Generate SHA-256 hash
//   var bytes = utf8.encode(buffer.toString());
//   var digest = sha256.convert(bytes);
//   print('Digest: ${digest.toString()}');

//   return digest.toString(); // 64-character hexadecimal MAC
// }


//    //acceptorID 
//    //feild 42; marchantId
//    //feild 32; first 6 digits of track2Data(feild 35)
//    //feild tag sequence number; feild 23 00 or 01(add 0 ) to the beginning)
//    //only send 52 for online card()


// //    field2 == > pan 
// // field4 == >amount ( E.g 000000000111 respresents 1.11 Naira)
// // field7 ==> transmissionDateAndTime
// // field11 == > sequenceNumber
// // field12 == > timeLocalTransaction
// // field13 ==> dateLocalTransaction
// // field14 ==> cardExpiry
// // field18 == >merchantCategoryCode(not sure what this is)
// // field22 ==> posEntryMode
// // field23 ==> panSequenceNumber (first 6 digits of track2Data)
// // field25 ==> posConditionCode(00)
// //field26 == > pinCaptureMode(04)
// //field28 ==> amountTransactionFee(D00000100)
// // field32 == >acquiringInstitutionIdCode(acceptorID)
// //field35 ==> track2Data
// // field37 ==> RRN
// // field40 ==> serviceCode(      'field40': '000')
// // field41==> TerminalId (interfaceDeviceSerialNumber)

// // field42 ==> MerchantId ()
//   // "field43": "ACCESS NATION MOBILE PH4AOTIGBASTRCOLANG",

// //    "field49": "566",

// // field52 ==> pinblock
// // field55 ==> IccData(unifiedPaymentIccData)
// // field123 == > posEntryMode(same as  'field22': '051',)
// // sessionId ==> SeesionKey gotten from network key request

// // String generateStan() {
// //   final random = Random();
// //   return random.nextInt(1000000).toString().padLeft(6, '0');
// // }

// String mac128 = generateMacc({
//   'field2': transactionData['applicationPrimaryAccountNumber'] ?? '',
//   'field3': '001000',
//   'field4': transactionData['amountAuthorized'] ?? '',
//   'field7': field7,
//   'field11': field11,
//   'field12': field12,
//   'field13': field13,
//   'field14': transactionData['expirationDate'] ?? '',
//   'field18': merchanttype,
//   'field22': '051',
//   'field23': "001",
//   'field25': '00',
//   'field26': '04',
//   'field28': 'D00000100',
//   'field32': transactionData['track2Data']?.substring(0, 6) ?? '000000',
//   'field35': transactionData['track2Data'] ?? '',
//   'field37': rrn,
//   'field40': '221',
//   'field41': '201146YD',
//   'field42': merchantId,
//   'field52': transactionData['pinBlockDUKPT'] ?? '',
//   'field55': transactionData['unifiedPaymentIccData'] ?? '',
//   'field123': '510101511344101',
//   "field43": "ACCESS NATION MOBILE PH4AOTIGBASTRCOLANG",
//   "field49": "566",
//   'sessionId': "9d9ec798e3d54c45e0bcd5c11f2901ad",
//   'terminalId': '201146YD',
//   'terminalSerial': transactionData['interfaceDeviceSerialNumber'] ?? '083030303030303031',
// });

// var data = {
//   'field2': transactionData['applicationPrimaryAccountNumber'] ?? '',
//   'field3': '001000',
//   'field4': transactionData['amountAuthorized'] ?? '',
//   'field7': field7,
//   'field11': field11,
//   'field12': field12,
//   'field13': field13,
//   'field14': transactionData['expirationDate'] ?? '',
//   'field18': merchanttype,
//   'field22': '051',
//   'field23': "001",
//   'field25': '00',
//   'field26': '04',
//   'field28': 'D00000100',
//   'field32': transactionData['track2Data']?.substring(0, 6) ?? '000000',
//   'field35': transactionData['track2Data'] ?? '',
//   'field37': rrn,
//   'field40': '221',
//   'field41': '201146YD',
//   'field42': merchantId,
//   'field52': transactionData['pinBlockDUKPT'] ?? '',
//   'field55': transactionData['unifiedPaymentIccData'] ?? '',
//   'field123': '510101511344101',
//   'field128': mac128,
//   "field43": "ACCESS NATION MOBILE PH4AOTIGBASTRCOLANG",
//   "field49": "566",
//   'sessionId': "9d9ec798e3d54c45e0bcd5c11f2901ad",
//   'terminalId': '201146YD',
//   'terminalSerial': transactionData['interfaceDeviceSerialNumber'] ?? '083030303030303031',
// };


//     print('Processing transaction with data: $data');

//     isLoading.value = true;
//     try {
//       var res = await Api().post(Endpoints.PROCESSPAYMENT, data);
//       isLoading.value = false;

//       if (res.respCode == 0) {
//         print('Transaction successful');
//         Get.offAll(() => ReceiptScreen(
//           cardData: transactionData,
//           amount: (int.parse(transactionData['amount'] ?? '0') / 100).toStringAsFixed(2),
//           isSuccess: true,
//           message: 'Transaction successful',
//         ));
//       } else {
//         print('Transaction failed: ${res.respDesc}');
//         Get.offAll(() => ReceiptScreen(
//           cardData: transactionData,
//           amount: (int.parse(transactionData['amount'] ?? '0') / 100).toStringAsFixed(2),
//           isSuccess: false,
//           message: 'Transaction failed: ${res.respDesc}',
//         ));
//       }
//     } catch (e) {
//       isLoading.value = false;
//       print('API error: $e');
//       Get.snackbar('Error', 'Failed to process transaction: $e');
//       Get.offAll(() => ReceiptScreen(
//         cardData: transactionData,
//         amount: (int.parse(transactionData['amount'] ?? '0') / 100).toStringAsFixed(2),
//         isSuccess: false,
//         message: 'Transaction failed: Network error',
//       ));
//     }
//   }
// }

// Future processResult(Map<String, dynamic> transactionData) async {
//   final now = DateTime.now();
//   final field7 = DateFormat('MMddHHmmss').format(now);
//   final field11 = generateStan(); // Implement this function to generate a unique 6-digit STAN
//   final field12 = DateFormat('HHmmss').format(now);
//   final field13 = DateFormat('MMdd').format(now);

//   var data = {
//     'field2': transactionData['applicationPrimaryAccountNumber'] ?? '',
//     'field3': transactionData['processingCode'] ?? '000000',
//     'field4': transactionData['amount'] ?? '',
//     'field7': field7,
//     'field11': field11,
//     'field12': field12,
//     'field13': field13,
//     'field14': transactionData['expirationDate'] ?? '',
//     'field18': transactionData['merchantType'] ?? '',
//     'field22': transactionData['posEntryMode'] ?? '',
//     'field23': transactionData['cardSequenceNumber'] ?? '',
//     'field25': transactionData['posConditionCode'] ?? '',
//     'field26': transactionData['posCaptureCode'] ?? '',
//     'field28': transactionData['transactionFee'] ?? '',
//     'field32': transactionData['acquiringInstitutionId'] ?? '',
//     'field35': transactionData['track2Data'] ?? '',
//     'field37': transactionData['retrievalReferenceNumber'] ?? '',
//     'field40': transactionData['serviceRestrictionCode'] ?? '',
//     'field41': transactionData['terminalId'] ?? '083030303030303031',
//     'field42': transactionData['merchantId'] ?? '',
//     'field43': transactionData['cardAcceptorNameLocation'] ?? '',
//     'field49': transactionData['transactionCurrencyCode'] ?? '0360',
//     'field52': transactionData['pinBlock'] ?? '',
//     'field55': transactionData['iccDataString'] ?? '',
//     'field59': transactionData['additionalData'] ?? '',
//     'field123': transactionData['transactionLifeCycleId'] ?? '',
//     'field128': transactionData['messageAuthenticationCode'] ?? '',
//     'sessionId': transactionData['sessionId'] ?? '',
//     'terminalSerial': transactionData['interfaceDeviceSerialNumber'] ?? '083030303030303031',
//   };

//   log('Processing transaction with data: $data');

//   isLoading.value = true;
//   var res = await Api().post(Endpoints.PROCESSPAYMENT, data);
//   isLoading.value = false;

//   if (res.respCode == 0) {
//     print('Transaction successful');
//     Get.offAll(() => ReceiptScreen(
//       cardData: transactionData,
//       amount: transactionData['amount']?.toString() ?? '0.00',
//       isSuccess: true,
//       message: 'Transaction successful',
//     ));
//   } else {
//     Get.offAll(() => ReceiptScreen(
//       cardData: transactionData,
//       amount: transactionData['amount']?.toString() ?? '0.00',
//       isSuccess: false,
//       message: 'Transaction failed',
//     ));
//   }
// }

  // generateStan() {
  //   // Generate a unique 6-digit STAN (System Trace Audit Number)
  //   final now = DateTime.now();
  //   final random = DateTime.now().millisecondsSinceEpoch % 1000000; // Random number between 0 and 999999
  //   return random.toString().padLeft(6, '0'); // Ensure it's 6 digits
  // }


//   Future processResult(Map<String, dynamic> transactionData) async {
//     var data = {
//       'pan': transactionData['applicationPrimaryAccountNumber'] ?? '',
//       'amount': transactionData['amount'] ?? '',
//       'pin': transactionData['pinBlock'] ?? '',
//       'expiryDate': transactionData['expirationDate'] ?? '',
//       'track2': transactionData['track2Data'] ?? '', 
//       'terminalId': transactionData['interfaceDeviceSerialNumber'] ?? '083030303030303031', 
//       'iccData': transactionData['iccDataString'] ?? '',
//       'cardHolderName': transactionData['cardHolderName'] ?? '',
//       'applicationInterchangeProfile': transactionData['applicationInterchangeProfile'] ?? '',
//       'applicationTransactionCounter': transactionData['applicationTransactionCounter'] ?? '',
//       'cryptogram': transactionData['cryptogram'] ?? '',
//       'cryptogramInformationData': transactionData['cryptogramInformationData'] ?? '',
//       'issuerApplicationData': transactionData['issuerApplicationData'] ?? '',
//       'terminalCountryCode': transactionData['terminalCountryCode'] ?? '0360',
//       'transactionCurrencyCode': transactionData['transactionCurrencyCode'] ?? '0360',
//       'transactionDate': transactionData['transactionDate'] ?? '250429',
//       'transactionType': transactionData['transactionType'] ?? '00',
//       'unpredictableNumber': transactionData['unpredictableNumber'] ?? '',
//       'pinBlock': transactionData['pinBlock'] ?? '', 
//       'pinBlockDUKPT': transactionData['pinBlockDUKPT'] ?? '', 
//       'pinBlockTrippleDES': transactionData['pinBlockTrippleDES'] ?? '',
//       'terminalCapabilities': transactionData['terminalCapabilities'] ?? '',
//       'terminalType': transactionData['terminalType'] ?? '',
//       'terminalVerificationResults': transactionData['terminalVerificationResults'] ?? '',
//       'transactionSequenceCounter': transactionData['transactionSequenceCounter'] ?? '',
//       'applicationVersionNumber': transactionData['applicationVersionNumber'] ?? '',
//       'cardSequenceNumber': transactionData['cardSeqenceNumber'] ?? '', 
//       'cardholderVerificationMethod': transactionData['cardholderVerificationMethod'] ?? '',
//       'dedicatedFileName': transactionData['dedicatedFileName'] ?? '',
//       'applicationIssuerData': transactionData['applicationIssuerData'] ?? '',
//     };

//     isLoading.value = true;
//     var res = await Api().post(Endpoints.PROCESSPAYMENT, data);
//     isLoading.value = false;

//   if (res.respCode == 0) {
//   print('Transaction successful');
//  Get.offAll(() => ReceiptScreen(
//     cardData: transactionData,
//     amount: transactionData['amount']?.toString() ?? '0.00',
//     isSuccess: true,
//     message:
//     // res.respMessage ??
//      'Transaction successful',
//   ));
// } else {
// Get.offAll(()=> ReceiptScreen(
//     cardData: transactionData,
//     amount: transactionData['amount']?.toString() ?? '0.00',
//     isSuccess: false,
//     message:
//    //  res.respMessage ??
//       'Transaction failed',
//   ));
// }
//   }


  // Future keyExhange() async {
  // Pick the device serial number from platformVersion to the serial number

    //   var data = {
  //     'serialNumber': ',
  //   };

  //Response here from the endpoint, create a model and save this sessionKey, masterKey, tmasterKey, pinKy
//   {
//     "sessionKey": "788BFCD4BDF82FCF91D",
//     "masterKey": "3CD9A6",
//     "tmasterKey": "5EE41289F70C9D1907F1E0B88C7BECA7AD8789",
//     "pinKy": "317E7CD7582FCF91D",
//     "extendedAttributes": {
//         "transactionLimit": null,
//         "offlineLimit": "4",
//         "terminalType": null,
//         "language": null,
//         "currency": null,
//         "accountType": null,
//         "merchantId": null,
//         "terminalLocation": "",
//         "issuerInstitution": null
//     }
// }




  //   isLoading.value = true;
  //   var res = await Api().post(Endpoints.KeyExchange, data);
  //   isLoading.value = false;


  //   if (res.respCode == 0) {

  //save the sessionKey, masterKey, tmasterKey, pinKy to local storage using shared preferences

  //   } else {
  //     handleError(res.respDesc);
  //   }
 // }



  // Future keyExhange() async {
  //   try {
  //     isLoading.value = true;

  //     var data = {
  //       "terminalId": "201146YD",
  //       'serialNumber': deviceSerialNumber.value,
  //     };

  //     var res = await Api().post(Endpoints.KeyExchange, data);

  //     isLoading.value = false;

  //     if (res.respCode == 0) {
  //       // Extract keys from the response
  //       String sessionKey = res.data['sessionKey'];
  //       String masterKey = res.data['masterKey'];
  //       // String tmasterKey = '';
  //       // res.data['tmasterKey'];
  //       String pinKy = res.data['pinKey'];

  //       // Save keys to shared preferences
  //       await StorageService().saveSessionKey(sessionKey);
  //       await StorageService().saveMasterKey(masterKey);
  //       // await StorageService().saveTMasterKey(tmasterKey); //for UP
  //       await StorageService().savePinKy(pinKy);

  //       print('Keys saved successfully');
  //     } else {
  //       handleError(res.respDesc);
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     handleError('Failed to perform key exchange: $e');
  //   }
  // }



  // class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: KeyboardListener(
//         focusNode: FocusNode(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome'.tr,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge
//                   ?.copyWith(fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ActionItem(
//                   icon: 'dash_deposit',
//                   label: 'action_deposit'.tr,
//                   //  toScreen: DepositOneScreen(),
//                 ),
//                 ActionItem(
//                   icon: 'dash_withdrawal',
//                   label: 'action_withdraw'.tr,
//                   //   toScreen: WithdrawalScreen(),
//                 ),
//                 ActionItem(
//                   icon: 'dash_bills',
//                   label: 'action_bills'.tr,

//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ActionItem(
//                   icon: 'dash_balance',
//                   label: 'action_balance'.tr,
//                   //  toScreen: EnquiryScreen(),
//                 ),
//                 ActionItem(
//                   icon: 'dash_loan',
//                   label: 'action_loans'.tr,
//                   //toScreen: LoanScreen(),
//                 ),
//                 ActionItem(
//                   icon: 'dash_transfer',
//                   label: 'action_vas'.tr,
//                   //  toScreen: VasWelcome(),
//                 ),
//                 // Expanded(child: SizedBox())
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
