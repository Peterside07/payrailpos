import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:payrailpos/global/endpoints.dart';
import 'package:payrailpos/screen/home/withdraw/receipt.dart';
import 'package:payrailpos/service/api.dart';
import 'package:payrailpos/service/storage.dart';

class POSController extends GetxController {
  var isLoading = false.obs;

  var deviceSerialNumber = ''.obs;
  var selectedAccountType = ''.obs;

  Future keyExhange() async {
    try {
      // Check if keys are already stored
      final sessionKey = await StorageService().getSessionKey();
      final masterKey = await StorageService().getMasterKey();
      final pinKey = await StorageService().getPinKy();

      if (sessionKey != "" && masterKey != "" && pinKey != "") {
        print('Keys already exist. Skipping key exchange.');
        print('Session Key: $sessionKey');
        print('Master Key: $masterKey');
        print('Pin Key: $pinKey');
        return;
      }

      isLoading.value = true;

      var data = {
        "terminalId": "201146YD",
        'terminalSerial': "98221207923032"
        // deviceSerialNumber.value,
      };

      var res = await Api().post(Endpoints.KeyExchange, data);
      isLoading.value = false;

      if (res.respCode == 0) {
        // Save keys to storage
        await StorageService().saveSessionKey(res.data['sessionKey']);
        await StorageService().saveMasterKey(res.data['masterKey']);
        await StorageService().savePinKy(res.data['pinKey']);

        print('Session Key: ${res.data['sessionKey']}');
        print("Master Key: ${res.data['masterKey']}");
        print('Pin Key: ${res.data['pinKey']}');

        print('Keys exchanged and saved successfully.');
      } else {
        handleError(res.respDesc);
      }
    } catch (e) {
      isLoading.value = false;
      handleError('Failed to perform key exchange: $e');
    }
  }

  String generateMacc(Map<String, dynamic> message) {
    // Remove field128 if it exists — it shouldn't be part of the hash
    Map<String, dynamic> filteredMessage = Map.of(message)..remove('field128');

    // Sort keys (assuming order matters)
    var sortedKeys = filteredMessage.keys.toList()..sort();

    // Build the message string (concatenate all values in field order)
    StringBuffer buffer = StringBuffer();
    for (var key in sortedKeys) {
      var value = filteredMessage[key];
      if (value != null && value is String) {
        buffer.write(value);
      }
    }
    print('Buffer: ${buffer.toString()}');

    // Generate SHA-256 hash
    var bytes = utf8.encode(buffer.toString());
    var digest = sha256.convert(bytes);
    print('Digest: ${digest.toString()}');

    return digest.toString(); // 64-character hexadecimal MAC
  }

  // Rest of the processResult function remains unchanged
  Future processResult(Map<String, dynamic> transactionData) async {
    final now = DateTime.now(); // 10:16 AM WAT, May 29, 2025
    final field7 = DateFormat('MMddHHmmss').format(now); // 0529101600
    final field11 = generateStan(); // e.g., 123456
    final field12 = DateFormat('HHmmss').format(now); // 101600
    final field13 = DateFormat('MMdd').format(now); // 0529

    const merchantId =
        '5045'; // Merchant type config (replace with PayU/terminal values)
    const acquirerId = '2011LA018411459'; //Merchant Category Code (MCC)

    var merchantType = '5045'; // Default MCC for PayU
    final sessionKey = await StorageService().getSessionKey();

    String mac128 = generateMacc({
      'field2': transactionData['applicationPrimaryAccountNumber'] ?? '',
      'field3': '001000',
      'field4': transactionData['amountAuthorized'] ?? '',
      'field7': field7,
      'field11': field11,
      'field12': field12,
      'field13': field13,
      'field14': transactionData['expirationDate'] ?? '',
      'field18': merchantType,
      'field22': '052', //pass 051 for online card
      'field23': "001",
      'field25': '00',
      'field26': '04',
      'field28': '00000100',
      'field32': transactionData['track2Data']?.substring(0, 6) ?? '000000',
      'field35': transactionData['track2Data'] ?? '',
      'field37': rrn,
      'field40': '221',
      'field41': '201146YD',
      'field42': merchantId,
      'field52': transactionData['pinBlock'] ?? '',
      'field55': transactionData['unifiedPaymentIccData'] ?? '',
      'field123': '510101511344101',
      "field43": "ACCESS NATION MOBILE PH4AOTIGBASTRCOLANG",
      "field49": "566",
      'sessionId': "9d9ec798e3d54c45e0bcd5c11f2901ad",
      'terminalId': '201146YD',
      'terminalSerial': transactionData['interfaceDeviceSerialNumber'] ??
          '083030303030303031',
    });

    var data = {
      'field2': transactionData['applicationPrimaryAccountNumber'] ?? '',
      'field3': '001000',
      'field4': transactionData['amountAuthorized'] ?? '',
      'field7': field7,
      'field11': field11,
      'field12': field12,
      'field13': field13,
      'field14': transactionData['expirationDate'] ?? '',
      'field18': merchantType,
      'field22': '051',
      'field23': "001",
      'field25': '00',
      'field26': '04',
      'field28': '00000100',
      'field32': transactionData['track2Data']?.substring(0, 6) ?? '000000',
      'field35': transactionData['track2Data'] ?? '',
      'field37': rrn,
      'field40': '221',
      'field41': '201146YD',
      'field42': acquirerId,
      'field52': transactionData['pinBlock'] ?? '',
      'field55': transactionData['unifiedPaymentIccData'] ?? '',
      'field123': '510101511344101',
      'field128': mac128,
      "field43": "ACCESS NATION MOBILE PH4AOTIGBASTRCOLANG",
      "field49": "566",
      'sessionId': sessionKey,
      'terminalId': '201146YD',
      'terminalSerial': transactionData['interfaceDeviceSerialNumber'] ??
          '083030303030303031',
    };

    print('Processing transaction with data: $data');

    isLoading.value = true;
    try {
      var res = await Api().post(Endpoints.PROCESSPAYMENT, data);
      isLoading.value = false;

      if (res.respCode == 0) {
        print('Transaction successful');
        Get.offAll(() => ReceiptScreen(
              cardData: transactionData,
              amount: (int.parse(transactionData['amount'] ?? '0') / 100)
                  .toStringAsFixed(2),
              isSuccess: true,
              message: 'Transaction successful',
            ));
      } else {
        print('Transaction failed: ${res.respDesc}');
        Get.offAll(() => ReceiptScreen(
              cardData: transactionData,
              amount: (int.parse(transactionData['amount'] ?? '0') / 100)
                  .toStringAsFixed(2),
              isSuccess: false,
              message: 'Transaction failed: ${res.respDesc}',
            ));
      }
    } catch (e) {
      isLoading.value = false;
      print('API error: $e');
      Get.snackbar('Error', 'Failed to process transaction: $e');
      Get.offAll(() => ReceiptScreen(
            cardData: transactionData,
            amount: (int.parse(transactionData['amount'] ?? '0') / 100)
                .toStringAsFixed(2),
            isSuccess: false,
            message: 'Transaction failed: Network error',
          ));
    }
  }
}

void handleError(String message) {
  Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
}

// Generate a unique 6-digit STAN
String generateStan() {
  final random = Random();
  return random.nextInt(1000000).toString().padLeft(6, '0');
}

// Generate SHA-256 MAC for field128
String generateMac(String message, String workingKey) {
  try {
    var keyBytes = hexToBytes(workingKey);
    var messageBytes = utf8.encode(message);
    var hmac = Hmac(sha256, keyBytes); // Use sha256 from crypto package
    var digest = hmac.convert(messageBytes);
    return digest.toString().toUpperCase().substring(0, 64);
  } catch (e) {
    print('Error generating MAC: $e');
    return '0' * 64; // Fallback
  }
}

// Convert hex string to bytes
List<int> hexToBytes(String hex) {
  var bytes = <int>[];
  for (var i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return bytes;
}

final _secureRandom = Random.secure();

/// Generates a 12-digit secure Retrieval Reference Number (RRN)
/// Format: MMddHHmmssNN
String generateRetrievalRef() {
  final now = DateTime.now().toUtc(); // Use UTC to ensure consistency
  final timePart = DateFormat('MMddHHmmss').format(now); // 10 digits

  final randomSuffix =
      _secureRandom.nextInt(100).toString().padLeft(2, '0'); // 2 digits

  final rrn = '$timePart$randomSuffix';

  assert(rrn.length == 12, 'RRN must be exactly 12 digits');

  return rrn;
}

final rrn = generateRetrievalRef();
