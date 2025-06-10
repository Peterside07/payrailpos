import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:payrailpos/global/endpoints.dart';
import 'package:payrailpos/screen/home/withdraw/receipt.dart';
import 'package:payrailpos/service/api.dart';
import 'package:payrailpos/service/storage.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha1.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';

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


    // {"field2":"5399239049940101","field3":"001000","field4":"0000000001000","field7":"0602134606","field11":"476709","field12":"134606","field13":"0602","field14":"2711","field18":"5045","field22":"052","field23":"001","field25":"00","field26":"04","field28":"00000100","field32":"539923","field35":"5399239049940101D2711221017510955","field37":"060212445884","field40":"221","field41":"201146YD","field42":"2011LA018411459","field55":"82023900950500002480009A032506029C01005F2A0203609F02060000005000009F03060000000000009F10120110A040002C0000000000000000000000FF9F1A0203609F2608285AA09FB91162BF9F3303E0F8C89F34034203009F3501229F360200499F2701809F37049AF873CD","field123":"510101511344101","field128":"796ff41d47b68362b4b7071758d1ccb2b20b5341ebea450d3520d6a0bd62d58d","field43":"ACCESS NATION MOBILE PH4AOTIGBASTRCOLANG","field49":"566","sessionId":"34ecd5c28a987089736eb9d63875e9d5","terminalId":"201146YD","terminalSerial":"083030303030303031"}

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
      // 'field52': transactionData['pinBlock'] ?? '',
      'field55': transactionData['unifiedPaymentIccData'] ?? '',
      'field123': '510101511344101',
      "field43": "ACCESS NATION MOBILE PH4AOTIGBASTRCOLANG",
      "field49": "566",
      'sessionId': sessionKey,
      'terminalId': '201146YD',
      'terminalSerial': transactionData['interfaceDeviceSerialNumber'] ??
          '083030303030303031',
    });

    String pinBlock = Encrypt.encrypt(transactionData['plainPinKey']);

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
      // 'field52': transactionData['plainPinKey'] ?? '',
      'field55': transactionData['unifiedPaymentIccData'] ?? '',
      'field123': '510101511344101',
      'field128': mac128,
      "field43": "ACCESS NATION MOBILE PH4AOTIGBASTRCOLANG",
      "field49": "566",
      'sessionId':
      // "3d299e5197b6048949e5619de9372929",
      sessionKey,
      'terminalId': '201146YD',
      'terminalSerial': '98221207923032'
      // transactionData['interfaceDeviceSerialNumber'] ??
          //'083030303030303031',
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



  class Encrypt {
  static const int _keySize = 256;
  static const int _derivationIterations = 1000;
  static const String _algorithm = "AES";
  static const int _saltSize = 32; // 256 bits (not 128 as in comment)
  static const int _ivSize = 32; // 256 bits (not 128 as in comment)

  // You'll need to replace these with your actual values from PosApplication
  static String get _ipeklive =>
      "FB1668801FCE2F67AE0761A480F47598"; // Replace with actual password
  static String get _ksnlive =>
      "2a973468323191f88664130e5e312c70"; // Replace with actual algorithm

  /// Encrypts plaintext using AES encryption with PBKDF2 key derivation
  /// [plainText] The text to encrypt
  /// Returns Base64 encoded string containing salt + IV + encrypted data
  static String encrypt(String plainText) {
    try {
      // Generate random salt and IV
      final salt = _generate256BitsOfRandomEntropy();
      final iv =
          _generate128BitsOfRandomEntropy(); // IV should be 128 bits for AES

      // Convert plaintext to bytes
      final plainTextBytes = utf8.encode(plainText);

      // Derive key from password using PBKDF2
      final key = _deriveKey(_ipeklive, salt);

      // Initialize cipher for encryption
      final cipher = PaddedBlockCipher('AES/CBC/PKCS7');
      final params =
          PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
            ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
            null,
          );

      cipher.init(true, params); // true for encryption

      // Encrypt the plaintext
      final encryptedBytes = cipher.process(Uint8List.fromList(plainTextBytes));

      // Concatenate salt + IV + encrypted data
      final result = Uint8List(salt.length + iv.length + encryptedBytes.length);
      result.setRange(0, salt.length, salt);
      result.setRange(salt.length, salt.length + iv.length, iv);
      result.setRange(salt.length + iv.length, result.length, encryptedBytes);

      // Return Base64 encoded result
      return base64.encode(result);
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypts ciphertext that was encrypted using the encrypt method
  /// [cipherText] Base64 encoded string containing salt + IV + encrypted data
  /// [password] The password used for encryption
  /// Returns the decrypted plaintext
  static String decrypt(String cipherText, String password) {
    try {
      // Decode Base64 ciphertext
      final cipherTextBytesWithSaltAndIv = base64.decode(cipherText);

      // Extract salt (first 32 bytes)
      final salt = Uint8List(_saltSize);
      salt.setRange(0, _saltSize, cipherTextBytesWithSaltAndIv);

      // Extract IV (next 16 bytes) - IV for AES is always 128 bits
      final iv = Uint8List(16);
      iv.setRange(0, 16, cipherTextBytesWithSaltAndIv.skip(_saltSize));

      // Extract encrypted data (remaining bytes)
      final encryptedBytes = Uint8List(
        cipherTextBytesWithSaltAndIv.length - _saltSize - 16,
      );
      encryptedBytes.setRange(
        0,
        encryptedBytes.length,
        cipherTextBytesWithSaltAndIv.skip(_saltSize + 16),
      );

      // Derive key from password using same parameters as encryption
      final key = _deriveKey(password, salt);

      // Initialize cipher for decryption
      final cipher = PaddedBlockCipher('AES/CBC/PKCS7');
      final params =
          PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
            ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
            null,
          );

      cipher.init(false, params); // false for decryption

      // Decrypt the data
      final decryptedBytes = cipher.process(encryptedBytes);

      // Convert back to string
      return utf8.decode(decryptedBytes);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Derives a key from password and salt using PBKDF2
  static Uint8List _deriveKey(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA1Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, _derivationIterations, _keySize ~/ 8));
    return pbkdf2.process(utf8.encode(password));
  }

  /// Generates 256 bits (32 bytes) of cryptographically secure random data
  static Uint8List _generate256BitsOfRandomEntropy() {
    final random = Random.secure();
    final bytes = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }

  /// Generates 128 bits (16 bytes) of cryptographically secure random data for IV
  static Uint8List _generate128BitsOfRandomEntropy() {
    final random = Random.secure();
    final bytes = Uint8List(16);
    for (int i = 0; i < 16; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }
  }